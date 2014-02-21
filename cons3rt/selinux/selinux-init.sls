{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
include:
  - cons3rt.selinux.packages
  - cons3rt.baseline.packages

setroubleshoot-enabled:
  service:
    - running
    - names:
      - auditd
      - messagebus
    - enable: true
    - order: 1
    - require:
      - sls: cons3rt.selinux.packages
      - sls: cons3rt.baseline.packages

validate-selinux-initial-setup:
  file:
    - managed
    - name:  {{apps_path}}/.saltstack-actions/selinux-filesystem-relabeled
    - makedirs: true
    - contents: "SALTSTACK - LOCK FILE\nIf removed or modified in anyway, the file system will be relabeled for selinux\nand the system will restart."
    - user: root
    - group: root
    - mode: '0644'
    - order: 1

/etc/rc.d/rc.local:
  file:
    - managed
    - source: salt://cons3rt/selinux/templates/rc.local.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'
    - order: 1

set-filesystem-relabel:
  cmd:
    - wait
    - name: 'touch /.autorelabel'
    - order: 1
    - watch:
      - file: validate-selinux-initial-setup
    - require:
      - sls: cons3rt.selinux.packages
      - sls: cons3rt.baseline.packages
      - file: /etc/rc.d/rc.local

disable-salt-minion:
  cmd:
    - wait
    - name: '/sbin/chkconfig salt-minion off'
    - order: 1
    - watch:
      - file: /etc/rc.d/rc.local

ensure-selinux-permissive:
  module:
    - wait
    - name: file.sed
    - path: /etc/selinux/config
    - before: 'SELINUX=enforcing'
    - after: 'SELINUX=permissive'
    - order: 1
    - watch:
      - cmd: set-filesystem-relabel
    - require:
      - sls: cons3rt.selinux.packages

system-reboot-selinux-initialization:
  module:
    - wait
    - name: system.reboot
    - order: 1
    - watch:
      - cmd: set-filesystem-relabel
    - require:
      - module: ensure-selinux-permissive
      - cmd: disable-salt-minion
      - service: setroubleshoot-enabled

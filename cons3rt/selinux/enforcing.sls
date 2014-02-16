{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set selinux=salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
include:
  - cons3rt.selinux.packages
  - cons3rt.baseline.packages

{% if selinux|lower=='true' %}
validate-selinux-initial-setup:
  file:
    - managed
    - name:  {{apps_path}}/.saltstack-actions/selinux-filesystem-relabeled
    - makedirs: true
    - contents: "SALTSTACK - LOCK FILE\nIf removed or modified in anyway, the filesystem will be relabled for selinux\nfollowed by a system reboot."
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

system-reboot-selinux-relabel:
  module:
    - wait
    - name: system.reboot
    - order: 1
    - watch:
      - cmd: set-filesystem-relabel

selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
    - require:
      - file: validate-selinux-initial-setup
      - file: /etc/rc.d/rc.local

set-selinux-config:
  augeas:
    - setvalue
    - prefix: /files/etc/selinux/config
    - changes:
      - SELINUX: enforcing
      - SELINUXTYPE: targeted
    - require:
      - sls: cons3rt.selinux.packages
      - sls: cons3rt.baseline.packages

{% endif %}


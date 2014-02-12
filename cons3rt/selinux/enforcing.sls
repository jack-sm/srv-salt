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
    - contents: 'SALTSTACK - LOCK FILE/nIf removed or modified in anyway, the filesystem will be relabled for selinux./n'
    - user: root
    - group: root
    - mode: '0644'

set-filesystem-relabel:
  cmd:
    - wait
    - name: touch /.autorelabel
    - watch:
      - file: validate-selinux-initial-setup
    - require:
      - sls: cons3rt.selinux.packages

selinux-enforcing:
  selinux:
    - mode:
    - name: enforcing

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

system-reboot-selinux-relabel:
  module:
    - wait
    - name: system.reboot
    - order: last
    - watch:
      - cmd: set-filesystem-relabel

{% endif %}


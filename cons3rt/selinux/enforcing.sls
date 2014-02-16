{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set selinux=salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
include:
  - cons3rt.selinux.packages
  - cons3rt.baseline.packages
  - cons3rt.selinux.selinux-init

{% if selinux|lower=='true' %}
selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
    - require:
      - sls: cons3rt.selinux.packages
      - sls: cons3rt.baseline.packages
      - sls: cons3rt.selinux.selinux-init

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
      - sls: cons3rt.selinux.selinux-init

{% endif %}


{% if salt['grains.get']('os')|lower=='amazon' %}
include:
  - cons3rt.baseline.yum-repositories
{% endif %}

selinux-packages:
  pkg:
    - installed
    - names:
      - libselinux
      - libselinux-utils
      - selinux-policy-mls
      - selinux-policy-minimum
      - selinux-policy-targeted
      - policycoreutils
      - policycoreutils-python
      - setroubleshoot-server
      - setroubleshoot-plugins
{% if salt['grains.get']('os')|lower=='amazon' %}
    - require:
      - sls: cons3rt.baseline.yum-repositories
{% endif %}

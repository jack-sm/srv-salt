{% if salt['grains.get']('os')|lower=='amazon' %}
include:
  - cons3rt.baseline.el6-repository
{% endif %}

/etc/samba/smb.conf:
  file:
    - managed
    - source: salt://cons3rt/cons3rt/templates/smb.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

samba:
  pkg:
    - installed
{% if salt['grains.get']('os')|lower=='amazon' %}
    - require:
      - sls: cons3rt.baseline.el6-repository
{% endif %}

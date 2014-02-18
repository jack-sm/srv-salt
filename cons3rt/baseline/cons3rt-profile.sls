{% set cons3rthome=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['fqdn'] %}
/etc/profile.d/cons3rt.sh:
  file:
    - managed
    - contents: "export CONS3RT_HOME=/net/{{cons3rthome}}/cons3rt\nexport PATH=${PATH}:${CONS3RT_HOME}/scripts\n"
    - user: root
    - group: root
    - mode: '0755'


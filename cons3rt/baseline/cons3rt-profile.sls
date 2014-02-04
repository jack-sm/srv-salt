create-cons3rt.sh:
  file:
    - managed
    - name: /etc/profile.d/cons3rt.sh
    - user: root
    - group: root
    - mode: '0644'

{% set cons3rthome=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['fqdn'] %}
/etc/profile.d/cons3rt.sh:
  file:
    - append
    - text:
      - export CONS3RT_HOME=/net/{{cons3rthome}}/cons3rt
      - export PATH=${PATH}:${CONS3RT_HOME}/scripts



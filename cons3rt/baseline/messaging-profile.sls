create-messaging.sh:
  file:
    - managed
    - name: /etc/profile.d/messaging.sh
    - user: root
    - group: root
    - mode: '0644'

{% set cons3rthome=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['fqdn'] %}
/etc/profile.d/messaging.sh:
  file:
    - append
    - text:
      - export JP_MSG_HOME=/net/{{cons3rthome}}/cons3rt/jackpine-messaging
      - export PATH=${PATH}:${JP_MSG_HOME}


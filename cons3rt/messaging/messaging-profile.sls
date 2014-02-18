{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
/etc/profile.d/messaging.sh:
  file:
    - managed
    - contents: "export JP_MSG_HOME={{apps_path}}/jackpine-messaging\nexport PATH=${PATH}:${JP_MSG_HOME}\n"
    - user: root
    - group: root
    - mode: '0755'


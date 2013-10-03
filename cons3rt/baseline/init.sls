# Disable and kill unnecessary services
{%for service in 'iptables','ip6tables','NetworkManager','autofs','bluetooth','cups','netfs'%}
disable-{{service}}:
  service:
    - dead
    - enable: False
{%endfor%}

# NTP needs to be on
cons3rt-ntp:
  service:
    - name: ntpd
    - running
    - enable: True

cons3rt-user-and-group:
  group.present:
    - name: cons3rt
    - gid: {{ pillar.get('cons3rt:gid','500') }}
  user.present:
    - name: cons3rt
    - home: /home/cons3rt
    - shell: /bin/bash
    - uid: {{ pillar.get('cons3rt:uid','500') }}
    - groups:
      - cons3rt
    - require:
      - group: cons3rt

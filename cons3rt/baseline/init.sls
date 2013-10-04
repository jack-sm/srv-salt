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

# Create Cons3rt user and group
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

drop-cons3rt.sh:
  file.managed:
    - name: /etc/profile.d/cons3rt.sh
    - source: salt://cons3rt/files/cons3rt.sh
    - wait:
      - file: drop-jsvc-binary

configure-cons3rt-nfs:
  file.directory:
    - name: /net/{{pillar.get('cons3rt:infrastructure:core-host:ip')}}/cons3rt
    - mkdirs: True
    - user: cons3rt
    - group: cons3rt
    - mode: 750
    - recurse:
      - user
      - group
  file.append:
    - name: /etc/fstab
    - text: 
      - {{pillar.get('cons3rt:infrastructure:core-host:ip')}}:/cons3rt /net/{{pillar.get('cons3rt:infrastructure:core-host:ip')}}/cons3rt nfs defaults 0 0
  service:
    - name: netfs
    - running
    - enable: True


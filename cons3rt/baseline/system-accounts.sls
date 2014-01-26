# All system accounts needed for the cons3rt infrastructure are managed below
cons3rt-account:
  group:
    - present
    - name: cons3rt
    - gid: {{ salt['pillar.get']('cons3rt-system-users:cons3rt:gid','500') }}
  user:
    - present
    - name: cons3rt
    - home: /home/cons3rt
    - shell: /bin/bash
    - createhome: True
    - uid: {{ salt['pillar.get']('cons3rt-system-users:cons3rt:uid','500') }}
    - groups:
      - cons3rt
    - require:
      - group: cons3rt-account

{% set webui=pillar['cons3rt-infrastructure']['hosts']['webinterface']['hostname'] %}
{% set assetrepo=pillar['cons3rt-infrastructure']['hosts']['assetrepository']['hostname'] %}
{% set messaging=pillar['cons3rt-infrastructure']['hosts']['messaging']['hostname'] %}

{% if grains['id']==messaging %}
jpmsg-account:
  group:
    - present
    - name: jpmsg
    - gid: {{ salt['pillar.get']('cons3rt-system-users:jpmsg:gid','501') }}
  user:
    - present
    - name: jpmsg
    - uid: {{ salt['pillar.get']('cons3rt-system-users:jpmsg:uid','501') }}
    - createhome: True
    - home: /cons3rt/jackpine-messaging
    - groups:
      - jpmsg
      - cons3rt
    - require:
      - group: jpmsg-account
      - group: cons3rt-account

{% elif grains['id']==assetrepo or grains['id']==webui %}
tomcat-account:
  group:
    - present
    - name: tomcat
    - gid: {{ salt['pillar.get']('cons3rt-system-users:tomcat:gid','502') }}
  user:
    - present
    - name: tomcat
    - uid: {{ salt['pillar.get']('cons3rt-system-users:tomcat:uid','502') }}
    - createhome: True
    - home: /home/tomcat
    - groups:
      - cons3rt
      - tomcat
    - require:
      - group: tomcat-account
      - group: cons3rt-account

{% endif %}

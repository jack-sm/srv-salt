# All system accounts needed for the cons3rt infrastructure are managed below
{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
/etc/login.defs:
  file:
    - sed
    - before: '500'
    - after: {{salt['pillar.get']('cons3rt-system-users:minimum_uid_gid','510')}}

{% if pillar['cons3rt-infrastructure']['infrastructure_type']|lower == 'aws' %}
modify-ec2-user-gid:
  group:
    - present
    - name: ec2-user
    - gid: {{salt['pillar.get']('cons3rt-system-users:ec2-user_gid','510')}}
{% endif %}

cons3rt-account:
  group:
    - present
    - name: cons3rt
    - gid: {{salt['pillar.get']('cons3rt-system-users:cons3rt:gid','500')}}
    - require:
      - file: /etc/login.defs
{% if pillar['cons3rt-infrastructure']['infrastructure_type']|lower == 'aws' %}
      - group: modify-ec2-user-gid{% endif %}
  user:
    - present
    - name: cons3rt
    - home: /home/cons3rt
    - shell: /bin/bash
    - createhome: true
    - uid: {{salt['pillar.get']('cons3rt-system-users:cons3rt:uid','500')}}
    - groups:
      - cons3rt
    - require:
      - group: cons3rt-account
      - file: /etc/login.defs

{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% if grains['id'] == hosts.messaging.fqdn %}
jpmsg-account:
  group:
    - present
    - name: jpmsg
    - gid: {{salt['pillar.get']('cons3rt-system-users:jpmsg:gid','501')}}
    - require:
      - file: /etc/login.defs
{% if pillar['cons3rt-infrastructure']['infrastructure_type']|lower == 'aws' %}
      - group: modify-ec2-user-gid{% endif %}
  user:
    - present
    - name: jpmsg
    - uid: {{salt['pillar.get']('cons3rt-system-users:jpmsg:uid','501')}}
    - createhome: true
    - home: {{apps_path}}/jackpine-messaging
    - groups:
      - jpmsg
      - cons3rt
    - require:
      - group: jpmsg-account
      - group: cons3rt-account
      - file: /etc/login.defs
{% endif %}

{% if grains['id'] == hosts.assetrepository.fqdn or grains['id'] == hosts.webinterface.fqdn %}
tomcat-account:
  group:
    - present
    - name: tomcat
    - gid: {{salt['pillar.get']('cons3rt-system-users:tomcat:gid','502')}}
    - require:
      - file: /etc/login.defs
{% if pillar['cons3rt-infrastructure']['infrastructure_type']|lower == 'aws' %}
      - group: modify-ec2-user-gid{% endif %}
  user:
    - present
    - name: tomcat
    - uid: {{salt['pillar.get']('cons3rt-system-users:tomcat:uid','502')}}
    - createhome: true
    - home: /home/tomcat
    - groups:
      - cons3rt
      - tomcat
    - require:
      - group: tomcat-account
      - group: cons3rt-account
      - file: /etc/login.defs
{% endif %}

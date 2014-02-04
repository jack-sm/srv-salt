include:
  - cons3rt.database.mysql.packages

cons3rt-database:
  mysql_database:
    - present
    - name: cons3rt
    - require:
      - sls: cons3rt.database.mysql.packages

{% set cons3rtdbpswdhash=pillar['cons3rt']['cons3rt_database_password'] %}
{% set cons3rtdbuser=salt['pillar.get']('cons3rt:cons3rt_database_user','cons3rt') %}
{% set domain=pillar['cons3rt-infrastructure']['domain'] %}
{% for vm in 'infrastructure','cons3rt','database','messaging','assetrepository','webinterface','sourcebuilder','testmanager' %}
{% set hostname=salt['pillar.get']('cons3rt-infrastructure:hosts:'~vm~':hostname','') %}
{% if hostname != '' %}
cons3rt-db-user-{{vm}}-fqdn:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{hostname}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-user-{{vm}}-hostname:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{hostname|replace('.'~domain,'')}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-{{vm}}-fqdn:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: true
    - database: cons3rt.*
    - host: {{hostname}}
    - require:
      - mysql_user: cons3rt-db-user-{{vm}}-fqdn

cons3rt-db-grant-{{vm}}-hostname:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: true
    - database: cons3rt.*
    - host: {{hostname|replace('.'~domain,'')}}
    - require:
      - mysql_user: cons3rt-db-user-{{vm}}-hostname
{% endif %}
{% endfor %}

{% for host in '127.0.0.1','localhost' %}
cons3rt-db-user-local-{{host}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{host}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-local-{{host}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - database: cons3rt.*
    - host: {{host}}
    - require:
      - mysql_user: cons3rt-db-user-local-{{host}}
{% endfor %}




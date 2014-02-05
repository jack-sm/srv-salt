{% set cons3rtdbpswdhash=pillar['cons3rt']['cons3rt_database_password'] %}
{% set cons3rtdbuser=salt['pillar.get']('cons3rt:cons3rt_database_user','cons3rt') %}
{% set domain=pillar['cons3rt-infrastructure']['domain'] %}
include:
  - cons3rt.database.mysql.packages

cons3rt-database:
  mysql_database:
    - present
    - name: cons3rt
    - require:
      - sls: cons3rt.database.mysql.packages

cons3rt-database-user:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: '{{cons3rtdbpswdhash}}'
    - require:
      - mysql_database: cons3rt-database

{% for vm in 'infrastructure','cons3rt','database','messaging','assetrepository','webinterface','sourcebuilder','testmanager' %}
{% set fqdn=salt['pillar.get']('cons3rt-infrastructure:hosts:'~vm~':fqdn','') %}
{% if fqdn != '' %}
cons3rt-db-grant-{{vm}}-fqdn:
  mysql_grants:
    - present
    - grant: ALL
    - database: cons3rt.*
    - user: {{cons3rtdbuser}}
    - host: {{fqdn}}
    - require:
      - mysql_user: cons3rt-database-user

cons3rt-db-grant-{{vm}}-hostname:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - database: cons3rt.*
    - host: {{fqdn|replace('.'~domain,'')}}
    - require:
      - mysql_user: cons3rt-database-user
{% endif %}
{% endfor %}

{% for host in '127.0.0.1','localhost' %}
cons3rt-db-grant-local-{{host}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - database: cons3rt.*
    - host: {{host}}
    - require:
      - mysql_user: cons3rt-database-user
{% endfor %}




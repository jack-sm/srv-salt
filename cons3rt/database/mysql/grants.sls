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
{% set infra=pillar['cons3rt-infrastructure']['hosts'] %}
{% for vm in 'infrastructure','cons3rt','database','messaging','assetrepository','webinterface','sourcebuilder','testmanager','retina' %}
{% if infra.vm.hostname != null or == '' %}
cons3rt-db-user-{{infra.vm.hostname}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{infra.vm.hostname}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-user-{{infra.vm.hostname|replace('.'~domain,'')}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{infra.vm.hostname|replace('.'~domain,'')}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-{{infra.vm.hostname}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: True
    - database: cons3rt.*
    - host: {{infra.vm.hostname}}
    - require:
      - mysql_user: cons3rt-db-user-{{infra.vm.hostname}}

cons3rt-db-grant-{{infra.vm.hostname|replace('.'~domain,'')}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: True
    - database: cons3rt.*
    - host: {{infra.vm.hostname|replace('.'~domain,'')}}
    - require:
      - mysql_user: cons3rt-db-user-{{infra.vm.hostname|replace('.'~domain,'')}}
{% endif %}
{% endfor %}


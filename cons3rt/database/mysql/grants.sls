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
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% for host in hosts.hostname %}
{% if host %}
cons3rt-db-user-{{host}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{host}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-user-{{host|replace('.'~domain,'')}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{host|replace('.'~domain,'')}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-{{host}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: True
    - database: cons3rt.*
    - host: {{host}}
    - require:
      - mysql_user: cons3rt-db-user-{{host}}

cons3rt-db-grant-{{host|replace('.'~domain,'')}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - grant_option: True
    - database: cons3rt.*
    - host: {{host}}
    - require:
      - mysql_user: cons3rt-db-user-{{host|replace('.'~domain,'')}}
{% endif %}
{% endfor %}


include:
  - cons3rt.database.mysql.packages

cons3rt-database:
  mysql_database:
    - present
    - name: cons3rt
    - require:
      - sls: cons3rt.database.mysql.packages

{% set cons3rtdbpswdhash=pillar['cons3rt']['db-password-hashed'] %}
{% set cons3rtdbuser=salt['pillar.get']('cons3rt:db-user','cons3rt') %}
{% for host in [''] %}
cons3rt-db-user-{{host}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: {{cons3rtdbpswdhash}}
    - host: {{host}}
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

{% endfor %}


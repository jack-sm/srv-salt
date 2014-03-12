{% set cons3rtdbpswdhash=pillar['cons3rt']['cons3rt_database_password'] %}
{% set cons3rtdbuser=salt['pillar.get']('cons3rt:cons3rt_database_user','cons3rt') %}
{% set domain=pillar['cons3rt-infrastructure']['domain'] %}
{% set infratype = salt['pillar.get']('cons3rt-infrastructure:infrastructure_type','undefined') %}
{% if salt['pkg.version']('mysql-server')[2]|int < 5 %}
  {% set grantvalue='all privileges' %}
{% else %}
  {% set grantvalue='all' %}
{% endif %}
{% if infratype|lower=='openstack' %}
  {% set saltmineips=salt['mine.get']('*'~domain,'network.ip_addrs') %}
{% endif %}
include:
  - cons3rt.database.mysql.packages

cons3rt-database:
  mysql_database:
    - present
    - name: cons3rt
    - require:
      - sls: cons3rt.database.mysql.packages

{% for vm in 'administration','cons3rt','database','messaging','assetrepository','webinterface','sourcebuilder','testmanager','remoteaccessgateway' %}
  {% set fqdn=salt['pillar.get']('cons3rt-infrastructure:hosts:'~vm~':fqdn','') %}
  {% if infratype|lower == 'aws' %}
    {% set ip=salt['pillar.get']('cons3rt-infrastructure:hosts:'~vm~':private_ip','') %}
  {% elif infratype|lower == 'openstack' %}
    {% if saltmineips[value['fqdn']] is not callable %}
      {% set ip=saltmineips[value['fqdn']][0] %}
    {% endif %}
  {% else %}
    {% set ip=salt['pillar.get']('cons3rt-infrastructure:hosts:'~vm~':ip','') %}
  {% endif %}

# Test if fqdn is actually defined in the pillar file
  {% if fqdn is defined and fqdn|lower!='none' %}
cons3rt-db-user-{{vm}}-fqdn:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: '{{cons3rtdbpswdhash}}'
    - host: {{fqdn}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-user-{{vm}}-hostname:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: '{{cons3rtdbpswdhash}}'
    - host: {{fqdn|replace('.'~domain,'')}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-{{vm}}-fqdn:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: all privileges
    - database: cons3rt.*
    - host: {{fqdn}}
    - require:
      - mysql_user: cons3rt-db-user-{{vm}}-fqdn

cons3rt-db-grant-{{vm}}-hostname:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: {{grantvalue}}
    - database: cons3rt.*
    - host: {{fqdn|replace('.'~domain,'')}}
    - require:
      - mysql_user: cons3rt-db-user-{{vm}}-hostname
  {% endif %}
# Test if ip is actually defined in the pillar file
  {% if ip is defined and ip|lower!='none' %}
cons3rt-db-user-{{vm}}-ip:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: '{{cons3rtdbpswdhash}}'
    - host: {{ip}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-{{vm}}-ip:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: {{grantvalue}}
    - database: cons3rt.*
    - host: {{ip}}
    - require:
      - mysql_user: cons3rt-db-user-{{vm}}-ip
  {% endif %}
{% endfor %}
# Ensure the cons3rt db user can access the database from the localhost
{% for host in '127.0.0.1','localhost' %}
cons3rt-db-user-local-{{host}}:
  mysql_user:
    - present
    - name: {{cons3rtdbuser}}
    - password_hash: '{{cons3rtdbpswdhash}}'
    - host: {{host}}
    - require:
      - mysql_database: cons3rt-database

cons3rt-db-grant-local-{{host}}:
  mysql_grants:
    - present
    - user: {{cons3rtdbuser}}
    - grant: {{grantvalue}}
    - database: cons3rt.*
    - host: {{host}}
    - require:
      - mysql_user: cons3rt-db-user-local-{{host}}
{% endfor %}


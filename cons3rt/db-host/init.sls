# 1) Ensure mysql and mysqld are installed and enabled
# 2) Create mysql user 'cons3rt' and set password.
# 3) Grant cons3rt login permissions from all cons3rt hosts, defined by:
# - fqdn
# - ip
# 4) Grant 'root' login permissions from the network domain

# Add additional salt minion config so we can interact with mysql
db-host-salt-config:
  file.managed:
    - name: /etc/salt/minion.d/mysql.conf
    - source: salt://mysql/salt-minion-mysql-info.conf # Will want to template this later
  service:
    - restart
    - watch:
      - file: db-host-salt-config

# Install mysql & mysqld and create 'cons3rt' user.
db-host-install-mysql:
  pkg.installed:
    - names:
      - mysql
      - mysql-server
  service:
    - name: mysqld
    - running
    - enable: True
    - require:
      - pkg: db-host-install-mysql
  mysql_user.present:
    - name: cons3rt
    - password: cons3rt # will need to change this to a hashed password
    - require:
      - pkg: db-host-install-mysql

# Grant permissions for logging in from localhost & loopback.
# NOTE: This state may return 'error' on a salt run. This is a known issue
# and can be safely ignored as the state has run successfully.
{% for host in '127.0.0.1','localhost'%}
db-host-cons3rt-grants-{{host['ip']}}:
  mysql_grants.present:
    - grant: all privileges
    - user: cons3rt
    - database: cons3rt.*
    - host: {{args['ip']}}
{% endfor %}

# Grant user cons3rt all privileges when logging in from any host 
# defined by either the fqdn or the IP.
{% for host, args in salt['pillar.get']('cons3rt:infrastructure').iteritems()%}
db-host-cons3rt-grants-{{args['fqdn']}}:
  mysql_grants.present:
    - use:
      - mysql_grants: db-host-cons3rt-grants-localhost
    - host: {{args['fqdn']}}

db-host-cons3rt-grants-{{host['ip']}}:
  mysql_grants.present:
    - use:
      - mysql_grants: db-host-cons3rt-grants-localhost
    - host: {{args['ip']}}
{% endfor %}

{% set cons3rt_domain = salt['pillar.get']('cons3rt:infra:network-domain') %}:
# Give root proper grants
db-host-root-mysql-grants-{{cons3rt_domain}}:
  mysql_grants.present:
    - user: root
    - grant: all privileges
    - database: *.*
    - host: {{cons3rt_domain}}

# Install JRE
include:
  - java.install-jre-into-opt

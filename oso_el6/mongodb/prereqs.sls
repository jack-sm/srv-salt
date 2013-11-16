include:
  - oso_el6.yum_repositories
  - oso_el6.selinux.permissive

mongodb-group:
  group:
    - present
    - name: mongodb
    - gid: 499
    - system: True

mongodb-user:
  user:
    - present
    - name: mongodb
    - fullname: MongoDB Database Server
    - shell: /sbin/nologin
    - home: /var/lib/mongodb
    - uid: 184
    - gid: 499
    - system: True
    - require:
      - group: mongodb-group

mongodb-server:
  pkg:
    - installed
    - prereqs:
      - sls: oso_el6.selinux.permissive
    - require:
      - sls: oso_el6.yum_repositories
      - user: mongodb-user

mongodb-set-smallfiles:
  file:
    - append
    - name: /etc/mongodb.conf
    - text:
      - smallfiles = true
    - require:
      - pkg: mongodb-server
      
mongod-initial-start:
  cmd:
    - wait
    - name: /etc/init.d/mongod start
    - watch:
      - pkg: mongodb-server
    - require:
      - file: mongodb-set-smallfiles

{% set oso_db_password=salt['pillar.get']('oso_el6:db_password') %}
setup-inital-mongodb-users:
  cmd:
    - wait
    - names:
       - /bin/sleep 4
       - /usr/bin/mongo localhost/openshift_broker --eval 'db.addUser("openshift", "{{oso_db_password}}")'
       - /bin/sleep 1
       - /usr/bin/mongo localhost/admin --eval 'db.addUser("openshift", "{{oso_db_password}}")'
    - watch:
      - cmd: mongod-initial-start


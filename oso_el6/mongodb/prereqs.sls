include:
  - oso_el6.yum_repositories

mongodb-server:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories

mongodb-set-smallfiles:
  file:
    - append
    - name: /etc/mongodb.conf
    - text:
      - smallfiles = true
      
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
       - /usr/bin/mongo localhost/openshift_broker --eval 'db.addUser("openshift", "{{oso_db_password}}")'
       - /usr/bin/mongo localhost/admin --eval 'db.addUser("openshift", "{{oso_db_password}}")'
    - watch:
      - cmd: mongod-initial-start


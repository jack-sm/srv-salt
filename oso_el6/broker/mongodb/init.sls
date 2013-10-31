include:
  - oso_el6.broker.mongodb.prereqs

/etc/mongodb.conf:
  file:
    - managed
    - source: salt://oso_el6/broker/mongodb/templates/mongodb.conf.jinja
    - template: jinja
    - require:
      - sls: oso_el6.broker.mongodb.prereqs

mongod-service:
  service:
    - name: mongod
    - running
    - enable: True
    - reload: True                      
    - watch:
      - file: /etc/mongodb.conf


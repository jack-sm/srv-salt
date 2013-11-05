include:
  - oso_el6.mongodb.prereqs

/etc/mongodb.conf:
  file:
    - managed
    - source: salt://oso_el6/mongodb/templates/mongodb.conf.jinja
    - template: jinja
    - require:
      - sls: oso_el6.mongodb.prereqs

mongod-service:
  service:
    - name: mongod
    - running
    - enable: True
    - reload: True                      
    - watch:
      - file: /etc/mongodb.conf


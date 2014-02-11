include:
  - cons3rt.baseline
  - cons3rt.database.mysql.packages
  - cons3rt.database.mysql.database-credentials
  - cons3rt.database.mysql.grants
 
mysqld:
  service:
    - running
    - enable: true
    - require:
      - sls: cons3rt.database.mysql.packages 

cons3rt-database-service:
  module:
    - wait
    - name: service.restart
    - m_name: mysqld
    - watch:
      - sls: cons3rt.database.mysql.packages


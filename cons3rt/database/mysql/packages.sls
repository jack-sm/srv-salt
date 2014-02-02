mysql-packages:
  pkg:
    - installed
    - names:
      - MySQL-python
      - mysql-server
      - mysql

mysqld:
  service:
    - running
    - enable: true


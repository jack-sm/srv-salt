apache-group:
  group:
    - present
    - name: apache
    - gid: 48
    - system: True

apache-user:
  user:
    - present
    - name: apache
    - fullname: Apache
    - shell: /sbin/nologin
    - home: /var/www
    - uid: 48
    - gid: 48
    - system: True
    - require:
      - group: apache-group


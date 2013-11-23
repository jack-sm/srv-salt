apache-user:
  user:
    - present
    - name: apache
    - fullname: Apache
    - shell: /sbin/nologin
    - home: /var/www
    - system: True


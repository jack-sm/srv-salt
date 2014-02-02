database-minion-credentials:
  file:
    - managed
    - name: /etc/salt/minion.d/cons3rt-mysql.conf
    - source: salt://cons3rt/database/mysql/templates/cons3rt-mysql.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

database-minion-credentials:
  file:
    - managed
    - name: /etc/salt/minion.d/cons3rt-mysql.conf
    - user: root
    - group: root
    - mode: '0644'
    - contents:
      - mysql.host: 'localhost'
      - mysql.port: {{salt['pillar.get']('cons3rt:mysql_communication_port','3306')}}
      - mysql.user: 'root'
      - mysql.pass: ''
      - mysql.db: 'mysql'
      - mysql.charset: 'utf8'

commons-daemon:
  file:
    - managed
    - name: /opt/commons-daemon/jsvc
    - source: salt://cons3rt/packages/commons-daemon/jsvc/rhel6-x64/jsvc
    - makedirs: True
    - user: root
    - group: root
    - mode: '0755'



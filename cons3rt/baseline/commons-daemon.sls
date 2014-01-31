commons-daemon:
  file:
    - managed
    - name: /opt/commons-daemon/jsvc
    - source: salt://packages/commons-daemon/jsvc
    - makedirs: True



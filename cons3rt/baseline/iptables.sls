/etc/sysconfig/iptables:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/iptables.jinja
    - user: root
    - group: root
    - mode: '0600'
    - template: jinja

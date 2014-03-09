/etc/sysconfig/iptables:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/iptables.jinja
    - user: root
    - group: root
    - mode: '0600'
    - template: jinja

disable-ip6tables:
  service:
    - dead
    - name: ip6tables
    - enable: false

iptables:
  service:
    - running
    - enable: true
    - require:
      - file: /etc/sysconfig/iptables

reload-iptables:
  module:
    - wait
    - name: service.restart
    - m_name: iptables
    - order: last
    - watch:
      - file: /etc/sysconfig/iptables

reload-salt-minion-iptables:
  cmd:
    - wait
    - name: "/usr/bin/at now + 1 minute <<< '/sbin/service salt-minion restart'"
    - order: last
    - watch:
      - module: reload-iptables


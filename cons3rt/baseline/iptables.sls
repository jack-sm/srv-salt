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
    - m_name: iptables
    - watch:
      - file: /etc/sysconfig/iptables

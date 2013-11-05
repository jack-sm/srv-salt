manage-iptables-rules:
  file:
    - managed
    - name: /etc/sysconfig/iptables
    - source: salt://oso_el6/iptables/templates/iptables.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 600

iptables:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: manage-iptables-rules

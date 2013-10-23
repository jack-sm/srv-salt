{% set oso_broker_eth_device=salt['pillar.get']('oso_el6:broker:eth_device','eth0') %}
/etc/sysconfig/network:
  file:
    - managed
    - source: salt://oso_el6/broker/network/templates/network.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/sysconfig/network-scripts/ifcfg-{{oso_broker_eth_device}}:
  file:
    - managed
    - source: salt://oso_el6/broker/network/templates/ifcfg-eth.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

network:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/network-scripts/ifcfg-{{oso_broker_eth_device}}

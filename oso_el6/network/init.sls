{% set oso_broker_eth_device=salt['pillar.get']('oso_el6:broker:eth_device','eth0') %}
/etc/resolv.conf:
  file:
    - managed
    - source: salt://oso_el6/network/templates/resolv.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

{% set eth_device=salt['pillar.get']('oso_el6:broker:eth_device','eth0') %}
/etc/dhcp/dhclient-{{eth_device}}.conf:
  file:
    - managed
    - source: salt://oso_el6/network/templates/dhclient.conf.jinja
    - template: jinja

/etc/sysconfig/network:
  file:
    - managed
    - source: salt://oso_el6/network/templates/network.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/sysconfig/network-scripts/ifcfg-{{oso_broker_eth_device}}:
  file:
    - managed
    - source: salt://oso_el6/network/templates/ifcfg-eth.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

restart-network:
  cmd:
    - wait
    - name: /etc/init.d/network restart
    - watch:
      - file: /etc/sysconfig/network-scripts/ifcfg-{{oso_broker_eth_device}}

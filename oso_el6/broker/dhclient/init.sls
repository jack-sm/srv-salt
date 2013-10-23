{% set eth_device=salt['pillar.get']('oso_el6:broker:eth_device','eth0') %}
/etc/dhcp/dhclient-{{eth_device}}.conf:
  file:
    - managed
    - source: salt://oso_el6/broker/dhclient/templates/dhclient.conf.jinja
    - template: jinja


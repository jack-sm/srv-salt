{% set hosts=salt['pillar.get']('cons3rt-infrastructure:hosts') %}
{% set gateway=pillar['cons3rt-infrastructure']['gateway'] %}
{% set netmask=pillar['cons3rt-infrastructure']['netmask'] %}

{% for host, value in hosts.iteritems() %}
{% if value['fqdn']==grains['id'] %}
system:
  network:
    - system
    - enabled: true
    - hostname: {{value['fqdn']}}
    - gateway: {{gateway}}
    - gatewaydev: eth0
    - nozeroconf: true
    - require_reboot: true

eth0:
  network:
    - managed
    - enabled: true
    - type: eth
    - proto: none
    - ipaddr: {{value['ip']}}
    - netmask: {{netmask}}
{% break %}
{% endif %}
{% endfor %}


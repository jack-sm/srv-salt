{% set infratype = salt['pillar.get']('cons3rt-infrastructure:infrastructure_type','undefined') %}
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
{% if infratype|lower == 'kvm' or infratype|lower == 'vmware' %}
    - gateway: {{gateway}}
    - gatewaydev: eth0
    - nozeroconf: true{% endif %}
    - order: 2

{#-

Validating from pillar if system deployed into a managed infrastructure

-#}
{% if infratype|lower == 'kvm' or infratype|lower == 'vmware' %}
eth0:
  network:
    - managed
    - enabled: true
    - type: eth
    - proto: none
    - ipaddr: {{value['ip']}}
    - netmask: {{netmask}}
    - order: 2
{% endif %}{% break %}{% endif %}{% endfor %}

restart-network:
  module:
    - wait
    - name: service.restart
    - m_name: network
    - order: last
    - watch:
      - network: eth0

restart-system:
  module:
    - wait
    - name: system.reboot
    - order: last
    - watch:
      - network: system


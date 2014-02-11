{% set domain=pillar['cons3rt-infrastructure']['domain'] %}
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% set fqdn=grains['id']~'.'~domain %}
{% set gateway=pillar['cons3rt-infrastructure']['gateway'] %}
{% set netmask=pillar['cons3rt-infrastructure']['netmask'] %}

{% for assignment in ['cons3rt','assetrepository','administration','database','messaging','sourcebuilder','testmanager','webinterface'] %}
    #{% if hosts[assignment]['fqdn'] is defined %} 
        {% if grains['id'] == hosts[assignment]['fqdn']  %}
            {% set ip=hosts[assignment]['ip'] %}{% endif %}
    #{% endif %}
{% endfor %}

system:
  network:
    - system
    - enabled: true
    - hostname: {{fqdn}}
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
    - ipaddr: {{ip}}
    - netmask: {{netmask}}

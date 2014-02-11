{% set sourcebuilder = salt['pillar.get']('cons3rt-infrastructure:hosts:sourcebuilder:fqdn','undefined') %}
{% set infratype = salt['pillar.get']('cons3rt-infrastructure:infrastructure_type','undefined') %}
include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share','system-accounts','iptables','ntp','packages','admin-users' %}
  - cons3rt.baseline.{{state}}
{% endfor %}
{% if grains['id'] == sourcebuilder %}
  - cons3rt.baseline.java-jdk
{% else %}
  - cons3rt.baseline.java-jre
{% endif %}
{% if infratype|lower == 'kvm' or infratype|lower == 'vmware' %}
  - cons3rt.baseline.resolv
  - cons3rt.baseline.network
{% endif %}


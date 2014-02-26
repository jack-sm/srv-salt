{% set sourcebuilder = salt['pillar.get']('cons3rt-infrastructure:hosts:sourcebuilder:fqdn','undefined') %}
{% set infratype = salt['pillar.get']('cons3rt-infrastructure:infrastructure_type','undefined') %}
{% set selinux = salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
include:
{% if selinux|lower == 'true' %}
  - cons3rt.selinux.enforcing
{% endif %}
{% for state in 'commons-daemon','cons3rt-profile','cons3rt-share','system-accounts','hosts','iptables','ntp','packages','admin-users','network' %}
  - cons3rt.baseline.{{state}}
{% endfor %}
{% if grains['id'] == sourcebuilder %}
  - cons3rt.baseline.java-jdk
{% else %}
  - cons3rt.baseline.java-jre
{% endif %}
{% if infratype|lower == 'kvm' or infratype|lower == 'vmware' %}
  - cons3rt.baseline.resolv
{% endif %}


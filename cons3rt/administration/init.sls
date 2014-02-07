include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre','packages' %}
  - cons3rt.baseline.{{state}}{% endfor %}

nc:
  pkg:
    - installed
    - latest


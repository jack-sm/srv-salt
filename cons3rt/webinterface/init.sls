include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.tomcat.package
  - cons3rt.webinterface.packages
  - cons3rt.webinterface.apache-configurations
{% if salt['pillar.get']('cons3rt:guacamole_installed_with_ui','false')|lower == 'true' %}
  - cons3rt.webinterface.guacamole{% endif %}



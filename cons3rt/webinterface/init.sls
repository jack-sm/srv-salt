include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.tomcat.package
  - cons3rt.webinterface.packages
  - cons3rt.webinterface.apache-configurations
{% if salt['pillar.get']('cons3rt:guacamole_installed_with_ui','false')|lower == 'true' %}
  - cons3rt.webinterface.guacamole{% endif %}

cons3rt-webinterface-services:
  service:
    - names:
      - httpd
      - tomcat
    - running
    - enable: true
    - require:
      - sls: cons3rt.tomcat.package
      - sls: cons3rt.webinterface.packages

restart-httpd:
  module:
    - wait
    - name: service.restart
    - m_name: httpd
    - watch:
      - sls: cons3rt.webinterface.packages
      - sls: cons3rt.webinterface.apache-configurations

restart-tomcat:
  module:
    - wait
    - name: service.restart
    - m_name: tomcat
    - watch:
      - sls: cons3rt.tomcat.package

{% if salt['pillar.get']('cons3rt:guacamole_installed_with_ui','false')|lower == 'true' %}
cons3rt-console-redirection-service:
  service:
    - name: guacd
    - running
    - enable: true
    - require:
      - sls: cons3rt.webinterface.guacamole

restart-guacamole:
  module:
    - wait
    - name: service.restart
    - m_name: guacd
    - watch:
      - sls: cons3rt.webinterface.guacamole
      - module: restart-httpd
      - module: restart-tomcat
{% endif %}


include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.tomcat.package
  - cons3rt.assetrepository.tomcat-configurations
  - cons3rt.assetrepository.jackrabbit

cons3rt-assetrepository-service:
  service:
    - name: tomcat
    - running
    - enable: true
    - require:
      - sls: cons3rt.tomcat.package
      - sls: cons3rt.assetrepository.tomcat-configurations
      - sls: cons3rt.assetrepository.jackrabbit

restart-tomcat:
  module:
    - wait
    - name: service.restart
    - m_name: tomcat
    - watch:
      - sls: cons3rt.tomcat.package
      - sls: cons3rt.assetrepository.tomcat-configurations
      - sls: cons3rt.assetrepository.jackrabbit


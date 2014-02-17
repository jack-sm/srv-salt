{% set selinux = salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
include:
  - cons3rt.baseline
  - cons3rt.tomcat.package
  - cons3rt.webinterface.tomcat-configurations
  - cons3rt.webinterface.packages
  - cons3rt.webinterface.apache-configurations

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
      - sls: cons3rt.webinterface.tomcat-configurations

{% if selinux|lower == 'true' %}
httpd-selinux:
  cmd:
    - run
    - name: /usr/sbin/setsebool -P httpd_can_network_relay=1
{% endif %}

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
      - sls: cons3rt.webinterface.tomcat-configurations


{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
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
httpd-selinux-setsebool-validation:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/httpd-selinux-setsebool-applied
    - makedirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\n/usr/sbin/setsebool -P httpd_can_network_relay=1 will be applied.\n"
    - user: root
    - group: root
    - mode: '0644'

httpd-selinux-setsebool:
  cmd:
    - wait
    - name: /usr/sbin/setsebool -P httpd_can_network_relay=1
    - watch:
      - file: httpd-selinux-setsebool-validation
{% endif %}

restart-httpd:
  module:
    - wait
    - name: service.restart
    - m_name: httpd
    - watch:
      - sls: cons3rt.webinterface.packages
      - sls: cons3rt.webinterface.apache-configurations
{% if selinux|lower == 'true' %}
      - cmd: httpd-selinux-setsebool{% endif %}

restart-tomcat:
  module:
    - wait
    - name: service.restart
    - m_name: tomcat
    - watch:
      - sls: cons3rt.tomcat.package
      - sls: cons3rt.webinterface.tomcat-configurations
{% if selinux|lower == 'true' %}
      - cmd: httpd-selinux-setsebool{% endif %}


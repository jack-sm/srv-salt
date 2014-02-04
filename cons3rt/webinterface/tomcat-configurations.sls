{% set apps_path = salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
include:
  - cons3rt.baseline.system-accounts
  - cons3rt.tomcat.package

{{apps_path}}/tomcat/config/server.xml:
  file:
    - managed
    - source: salt://cons3rt/tomcat/templates/webinterface-server.xml.jinja
    - template: jinja
    - user: tomcat
    - group: tomcat
    - mode: '0600'
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package

/etc/init.d/tomcat:
  file:
    - managed
    - source: salt://cons3rt/tomcat/templates/tomcat-init-webinterface.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package


{% set apps_path = salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
include:
  - cons3rt.baseline.system-accounts
  - cons3rt.tomcat.package

assetrepository-tomcat-server.xml:
  file:
    - managed
    - name: {{apps_path}}/tomcat/conf/server.xml
    - source: salt://cons3rt/tomcat/templates/assetrepository-server.xml.jinja
    - template: jinja
    - user: tomcat
    - group: tomcat
    - mode: '0600'
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package

assetrepository-tomcat-users.xml:
  file:
    - managed
    - name: {{apps_path}}/tomcat/conf/tomcat-users.xml
    - source: salt://cons3rt/tomcat/templates/assetrepository-tomcat-users.xml.jinja
    - template: jinja
    - user: tomcat
    - group: tomcat
    - mode: '0600'
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package

asssetrepository-tomcat-init:
  file:
    - managed
    - name: /etc/init.d/tomcat
    - source: salt://cons3rt/tomcat/templates/tomcat-init-assetrepository.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package


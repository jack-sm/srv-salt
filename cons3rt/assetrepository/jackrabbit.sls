{% set jrversion=salt['pillar.get']('cons3rt-packages:jackrabbit:version','') %}
{% set jackrabbit=salt['pillar.get']('cons3rt-packages:jackrabbit:package','') %}
{% set jcr=salt['pillar.get']('cons3rt-packages:jcr:package','') %}
{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
include:
  - cons3rt.baseline.system-accounts
  - cons3rt.tomcat.package

validate-jackrabbit-installed:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/jackrabbit-version-{{jrversion}}-deployed
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

deploy-jackrabbit-package:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{jackrabbit}}
    - dest: {{apps_path}}/{{jackrabbit}}
    - watch:
      - file: validate-jackrabbit-installed
  cmd:
    - wait
    - cwd: {{apps_path}}/.
    - name: unzip {{apps_path}}/{{jackrabbit}} -d {{apps_path}}/tomcat/webapps/jackrabbit
    - watch:
      - module: deploy-jackrabbit-package
    - require:
      - sls: cons3rt.tomcat.package

remove-jackrabbit-archive:
  module:
    - wait
    - name: file.remove
    - path: {{apps_path}}/{{jackrabbit}}
    - watch:
      - cmd: deploy-jackrabbit-package

{{apps_path}}/tomcat/webapps/jackrabbit/WEB-INF/web.xml:
  file:
    - managed
    - source: salt://cons3rt/assetrepository/templates/jackrabbit-web.xml.jinja
    - template: jinja
    - user: tomcat
    - group: tomcat
    - require:
      - file: validate-jackrabbit-installed

{{apps_path}}/tomcat/webapps/jackrabbit/WEB-INF/templates/bootstrap.properties:
  file:
    - managed
    - source: salt://cons3rt/assetrepository/templates/jackrabbit-bootstrap.properties.jinja
    - template: jinja
    - user: tomcat
    - group: tomcat
    - require:
      - file: validate-jackrabbit-installed

{{apps_path}}/tomcat/webapps/jackrabbit/WEB-INF/lib/{{jcr}}:
  file:
    - managed
    - source: salt://cons3rt/packages/{{jcr}}
    - user: tomcat
    - group: tomcat
    - require:
      - file: validate-jackrabbit-installed

{{apps_path}}/jackrabbit/repository.xml:
  file:
    - managed
    - source: salt://cons3rt/assetrepository/templates/repository.xml
    - user: tomcat
    - group: tomcat
    - require:
      - file: validate-jackrabbit-installed

{{apps_path}}/jackrabbit:
  file:
    - directory
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - require:
      - sls: cons3rt.baseline.system-accounts
      - sls: cons3rt.tomcat.package


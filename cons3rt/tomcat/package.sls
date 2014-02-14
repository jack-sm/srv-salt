{% set tomcat_package=pillar['cons3rt-packages']['tomcat']['package'] %}
{% set tomcat_version=pillar['cons3rt-packages']['tomcat']['version'] %}
{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
include:
  - cons3rt.baseline.system-accounts

tomcat-deployment-verification:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/tomcat-version-{{tomcat_version}}-deployed
    - makedirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in anyway,\napache tomcat version {{tomcat_version}} will be re-installed.\n"
    - user: root
    - group: root
    - mode: '0644'

deploy-tomcat:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{tomcat_package}}
    - dest: {{apps_path}}/{{tomcat_package}}
    - watch:
       - file: tomcat-deployment-verification
  cmd:
    - wait
    - name: tar -zxf {{tomcat_package}}
    - cwd: {{apps_path}}/
    - watch:
      - module: deploy-tomcat

remove-tomcat-archive:
  module:
    - wait
    - name: file.remove
    - path: {{apps_path}}/{{tomcat_package}}
    - watch:
      - cmd: deploy-tomcat

create-tomcat-symlink:
  file:
    - symlink
    - name: {{apps_path}}/tomcat
    - target: {{apps_path}}/{{tomcat_package|replace('.tar.gz','')}}
    - require:
      - module: deploy-tomcat

manage-tomcat-directory-ownership:
  file:
    - directory
    - name: {{apps_path}}/tomcat
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - require:
      - sls: cons3rt.baseline.system-accounts    

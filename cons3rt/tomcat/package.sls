{% set tomcat_package = pillar['cons3rt-packages']['tomcat']['package'] %}
{% set tomcat_version = pillar['cons3rt-packages']['tomcat']['version'] %}
{% set apps_path = salt['pillar.get']('cons3rt-packages:application_path','/opt'%}
include:
  - cons3rt.baseline.system-accounts

tomcat-deployment-verification:
  file:
    - managed
    - name: {{apss_path}}/.tomcat-version-{{tomcat-version}}-deployed

deploy-tomcat:
  file:
    - managed
    - name: {{apps_path}}/{{tomcat_package}}
    - source: salt://cons3rt/packages/{{tomcat_package}}
  cmd:
    - wait
    - name: tar -zxf {{tomcat_package}}
    - cwd: {{apps_path}}/
    - watch:
      - file: deploy-tomcat
  file.symlink:
    - name: {{apps_path}}/tomcat
    - target: {{apps_path}}/{{tomcat_tarball|replace('.tar.gz','')}}
  file.directory:
    - name: {{apps_path}}/tomcat
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - require:
      - sls: cons3rt.baseline.system-accounts    

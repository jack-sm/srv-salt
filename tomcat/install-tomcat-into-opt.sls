{% set tomcat_tarball = pillar['cons3rt']['files']['tomcat-tarball'] %}
install-tomcat:
  file.managed:
    - name: /opt/{{tomcat_tarball}}
    - source: salt://tomcat/files/{{tomcat_tarball}}
  cmd.wait:
    - name: unzip {{tomcat_tarball}}
    - cwd: /opt/
    - require:
      - file: install-tomcat
  file.symlink:
    - name: /opt/tomcat
    - target: /opt/{{tomcat_tarball|replace('.zip','')}}
  file.directory:
    - name: /opt/tomcat
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group

tomcat-server-xml:
  file.managed:
    - name: /opt/tomcat/conf/server.xml
    - source: salt://tomcat/files/ui-host-tomcat-server.xml

  

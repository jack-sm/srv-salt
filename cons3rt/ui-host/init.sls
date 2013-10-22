include:
  - cons3rt.baseline
  - tomcat.install-tomcat-into-opt

ui-host-tomcat-user:
  group.present:
    - name: tomcat
    - gid: 501
  user.present:
    - name: tomcat
    - uid: 501
    - groups:
      - cons3rt
      - tomcat
    - require:
      - group: ui-host-tomcat-user


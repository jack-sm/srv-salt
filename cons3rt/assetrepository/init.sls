include:
  - cons3rt.baseline
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


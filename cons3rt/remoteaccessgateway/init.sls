include:
  - cons3rt.baseline.init
  - cons3rt.remoteaccessgateway.package
  - cons3rt.remoteaccessgateway.guacamole-configurations

remoteaccessgateway-service:
  service:
    - name: guacd
    - running
    - enable: true
    - require:
      - sls: cons3rt.baseline.init
      - sls: cons3rt.remoteaccessgateway.package
      - sls: cons3rt.remoteaccessgateway.guacamole-configurations

restart-guacamole:
  module:
    - wait
    - name: service.restart
    - m_name: guacd
    - watch:
      - sls: cons3rt.remoteaccessgateway.guacamole-configurations


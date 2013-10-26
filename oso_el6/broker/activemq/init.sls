include:
  - oso_el6.broker.activemq.prereqs

activemq:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - sls: oso_el6.broker.activemq.prereqs


include:
  - oso_el6.activemq.prereqs

activemq:
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - sls: oso_el6.activemq.prereqs
    - watch:
      - sls: oso_el6.activemq.prereqs

/var/run/activemq:
  file:
    - directory
    - user: activemq
    - group: activemq
    - mode: 750
    - require:
      - pkg: activemq-broker-packages

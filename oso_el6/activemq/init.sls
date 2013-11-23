include:
  - oso_el6.activemq.prereqs

activemq:
  service:
    - running

/var/run/activemq:
  file:
    - directory
    - user: activemq
    - group: activemq
    - mode: 750
    - require:
      - pkg: activemq-broker-packages

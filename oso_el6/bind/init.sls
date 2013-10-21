include:
  - oso_el6.bind.bind_prereqs

named:
  service:
  - running
  - enable: True
  - require:
     - sls: oso_el6.bind.bind_prereqs


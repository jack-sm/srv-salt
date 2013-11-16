include:
  - oso_el6.selinux.prereqs

permissive:
  selinux:
    - mode
    - require:
      - sls: oso_el6.selinux.prereqs

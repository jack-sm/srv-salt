include:
  - oso_el6.yum_repositories

mongodb-server:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories

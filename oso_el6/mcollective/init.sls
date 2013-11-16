include:
  - oso_el6.yum_repositories
  - oso_el6.selinux.permissive

mcollective-client:
  pkg:
    - installed
    - prereqs:
      - sls: oso_el6.selinux.permissive
    - require:
      - sls: oso_el6.yum_repositories

/etc/mcollective/client.cfg:
  file:
    - managed
    - source: salt://oso_el6/mcollective/templates/client.cfg.jinja
    - template: jinja
    - require:
      - pkg: mcollective-client

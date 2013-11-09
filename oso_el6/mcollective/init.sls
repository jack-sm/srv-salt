include:
  - oso_el6.yum_repositories
  - oso_el6.selinux

mcollective-client:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories
      - sls: oso_el6.selinux

/etc/mcollective/client.cfg:
  file:
    - managed
    - source: salt://oso_el6/mcollective/templates/client.cfg.jinja
    - template: jinja
    - require:
      - pkg: mcollective-client

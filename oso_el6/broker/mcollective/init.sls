include:
  - oso_el6.yum_repositories

mcollective-client:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories

/etc/mcollective/client.cfg:
  file:
    - managed
    - source: salt://oso_el6/broker/mcollective/templates/client.cfg.jinja
    - template: jinja
    - require:
      - pkg: mcollective-client

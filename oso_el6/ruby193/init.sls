include:
  - oso_el6.yum_repositories

ruby193:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories
  file:
    - managed
    - names:
      - /etc/profile.d/scl193.sh
      - /etc/sysconfig/mcollective
    - source: salt://oso_el6/ruby193/scripts/scl193.sh
    - mode: '0644'

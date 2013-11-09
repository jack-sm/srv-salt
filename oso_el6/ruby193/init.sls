include:
  - oso_el6.yum_repositories
  - oso_el6.selinux

ruby193:
  pkg:
    - installed
    - require:
      - sls: oso_el6.yum_repositories
      - sls: oso_el6.selinux
  file:
    - managed
    - names:
      - /etc/profile.d/scl193.sh
      - /etc/sysconfig/mcollective
    - source: salt://oso_el6/ruby193/scripts/scl193.sh
    - mode: '0644'

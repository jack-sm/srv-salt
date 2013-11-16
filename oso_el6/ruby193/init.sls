include:
  - oso_el6.yum_repositories
  - oso_el6.selinux.permissive

ruby193:
  pkg:
    - installed
    - prereqs:
      - sls: oso_el6.selinux.permissive
    - require:
      - sls: oso_el6.yum_repositories
  file:
    - managed
    - names:
      - /etc/profile.d/scl193.sh
      - /etc/sysconfig/mcollective
    - source: salt://oso_el6/ruby193/scripts/scl193.sh
    - mode: '0644'

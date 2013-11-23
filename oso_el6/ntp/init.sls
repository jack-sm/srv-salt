include:
  - oso_el6.selinux.permissive

ntp:
  pkg:
    - installed
  require:
    - sls: oso_el6.selinux.permissive

ntpd:
  service:
    - enable: True
    - running
    - require:
      - pkg: ntp

run-ntpdate:
  cmd:
    - wait
    - name: ntpdate time-c.nist.gov
    - watch:
      - service: ntpd
    - require:
      - service: ntpd


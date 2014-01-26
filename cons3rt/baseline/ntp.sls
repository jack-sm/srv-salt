ntp:
  pkg:
    - installed

ntpd:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ntp.conf

ntpdate:
  cmd:
    - wait
    - name: ntpdate time-c.nist.gov
    - watch:
      - service: ntpd
    - require:
      - service: ntpd



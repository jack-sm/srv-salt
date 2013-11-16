ntp:
  pkg:
    - installed

ntpd:
  service:
    - enable: True
    - running

run-ntpdate:
  cmd:
    - wait
    - name: ntpdate clock.redhat.com
    - watch:
      - service: ntpd


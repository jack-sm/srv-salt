ntp:
  service:
    - installed
    - enable: True
    - running
  cmd.wait:
    - name: ntpdate clock.redhat.com
    - watch:
      - service: ntp


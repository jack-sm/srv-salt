ntp:
  pkg:
    - installed

/etc/ntp.conf:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/ntp.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

ntpd:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ntp.conf



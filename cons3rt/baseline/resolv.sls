/etc/resolv.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://cons3rt/baseline/templates/resolv.conf.jinja
    - template: jinja
    - order: 2

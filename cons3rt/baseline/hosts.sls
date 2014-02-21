/etc/hosts:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/hosts.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - order: 2


/srv/salt/cons3rt.sls:
  file:
    - managed
    - source: salt://cons3rt/saltmaster/templates/cons3rt-states-top.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

/etc/sysconfig/nfs:
  file:
    - managed
    - source: salt://cons3rt/cons3rt/templates/sysconfig-nfs
    - user: root
    - group: root
    - mode: '0644'

/etc/exports:
  file:
    - managed
    - source: salt://cons3rt/cons3rt/templates/exports.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

nfs-utils:
  pkg:
    - installed

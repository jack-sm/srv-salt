include:
  - cons3rt.remoteaccessgateway.package

/var/run/guacd:
  file:
    - directory
    - makedirs: true
    - user: guacd
    - group: guacd
    - recurse:
      - user
      - group
    - require:
      - sls: cons3rt.remoteaccessgateway.package

/etc/init.d/guacd:
  file:
    - managed
    - source: salt://cons3rt/remoteaccessgateway/templates/guacd-init
    - template: jinja
    - user: root
    - group: root
    - mode: '0755'

/etc/sysconfig/guacd:
  file:
    - managed
    - source: salt://cons3rt/remoteaccessgateway/templates/guacd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

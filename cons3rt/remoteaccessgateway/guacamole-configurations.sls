{%- set rag=pillar['cons3rt-infrastructure']['hosts']['remoteaccessgateway']['fqdn'] -%}
include:
  - cons3rt.remoteaccessgateway.package

/etc/pki/tls/certs/{{rag}}.crt
  file:
    - managed
    - source: salt://cons3rt/tls/{{rag}}.crt
    - user: root
    - group: root
    - mode: '0644'

/etc/pki/tls/private/{{rag}}.key
  file:
    - managed
    - source: salt://cons3rt/tls/{{rag}}.key
    - user: root
    - group: root
    - mode: '0644'

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

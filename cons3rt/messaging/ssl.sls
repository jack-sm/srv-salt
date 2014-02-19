{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpidssldb=salt['pillar.get']('cons3rt:qpid_ssldb','/var/lib/qpidd/keys/server_db') %}
{% set qpidssldbpswd=pillar['cons3rt']['qpid_ssldb_password'] %}
{% set qpid_version=pillar['cons3rt-packages']['qpid']['version'] %}
{% set messaging=pillar['cons3rt-infrastructure']['hosts']['messaging']['fqdn'] %}
{% set cacert=pillar['cons3rt']['ca_certificate_filename'] %}
{% set canickname=pillar['cons3rt']['ca_certificate_alias'] %}
include:
  - cons3rt.messaging.package

validate-qpid-ssl-certificate-database-creation:
  file:
    - managed
    - file: {{apps_path}}/.saltstack_actions/qpid-{{qpid_version}}-ssl-certificate-database-created
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\nthe qpidd ssl certificate database will be re-created.\n"
    - user: root
    - group: root
    - mode: '0644'

/etc/pki/tls/certs/{{messaging}}.p12:
  file:
    - managed
    - source: salt://cons3rt/tls/{{messaging}}.p12
    - user: root
    - group: root
    - mode: '0644'

/etc/pki/tls/certs/{{cacert}}:
  file:
    - managed
    - source: salt://cons3rt/tls/{{cacert}}
    - user: root
    - group: root
    - mode: '0644'

remove-qpid-ssl-certificate-database:
  cmd:
    - wait
    - name: /bin/rm -rf {{qpidssldb}}
    - watch:
      - file: validate-qpid-ssl-certificate-database-creation

qpid-ssl-certificate-database-directory:
  file:
    - directory
    - name: {{qpidssldb}}
    - makedirs: true
    - user: qpidd
    - group: qpidd
    - mode: '0644'
    - recurse:
      - user
      - group
    - require:
      - sls: cons3rt.messaging.package

qpid-ssl-certificate-database-password-file:
  file:
    - managed
    - name: {{qpidssldb}}/pfile
    - contents: "{{qpidssldbpswd}}"
    - user: qpidd
    - group: qpidd
    - require:
      - file: qpid-ssl-certificate-database

qpid-ssl-certificate-database-creation:
  cmd:
    - wait
    - name: /usr/bin/certutil -N -d {{qpidssldb}} -f {{qpidssldb}}/pfile
    - watch:
      - cmd: remove-qpid-ssl-certificate-database
    - require:
      - file: qpid-ssl-certificate-database-directory
      - file: qpid-ssl-certificate-database-password-file

inject-certificate-qpid-ssl-database:
  cmd:
    - wait
    - name: pk12util -i /etc/pki/tls/certs/{{messaging}}.p12 -d {{qpidssldb}} -n {{messaging}} -w {{qpidssldb}}/pfile -k {{qpidssldb}}/pfile -v
    - watch:
      - cmd: qpid-ssl-certificate-database-creation
    - require:
      - file: /etc/pki/tls/certs/{{messaging}}.p12

inject-cacertificate-qpid-ssl-database:
  cmd:
    - wait
    - name: /usr/bin/certutil -A -d {{qpidssldb}} -n {{canickname}} -t"TC,," -a -i {{cacert}} -f {{qpidssldb}}/pfile
    - watch:
      - cmd: inject-certificate-qpid-ssl-database
    - require:
      - file: /etc/pki/tls/certs/{{cacert}}



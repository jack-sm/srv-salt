{%- set webinterface = pillar['cons3rt-infrastructure']['hosts']['webinterface']['fqdn'] -%}
{%- set cacert = salt['pillar.get']('cons3rt:ca_certificate_filename','undefined') -%}
include:
  - cons3rt.webinterface.packages

/etc/httpd/conf/httpd.conf:
  file:
    - managed
    - source: salt://cons3rt/webinterface/templates/httpd.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - sls: cons3rt.webinterface.packages

/etc/httpd/conf.d/ssl.conf:
  file:
    - managed
    - source: salt://cons3rt/webinterface/templates/ssl.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - sls: cons3rt.webinterface.packages

/etc/httpd/conf.d/cons3rt.conf:
  file:
    - managed
    - source: salt://cons3rt/webinterface/templates/cons3rt.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - sls: cons3rt.webinterface.packages

/etc/php.ini:
  file:
    - sed
    - before: ';date.timezone ='
    - after: 'date.timezone = {{salt['pillar.get']('cons3rt:php_timezone','America/New_York')}}'
    - require:
      - sls: cons3rt.webinterface.packages

/etc/pki/tls/certs/{{webinterface}}.crt:
  file:
    - managed
    - source: salt://cons3rt/tls/{{webinterface}}.crt
    - user: root
    - group: root
    - mode: '0600'

/etc/pki/tls/private/{{webinterface}}.key:
  file:
    - managed
    - source: salt://cons3rt/tls/{{webinterface}}.key
    - user: root
    - group: root
    - mode: '0400'

/etc/pki/tls/certs/{{cacert}}:
  file:
    - managed
    - source: salt://cons3rt/tls/{{cacert}}
    - user: root
    - group: root
    - mode: '0644'


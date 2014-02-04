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


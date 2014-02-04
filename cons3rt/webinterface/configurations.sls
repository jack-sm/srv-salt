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


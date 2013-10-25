include:
  - cons3rt.baseline
  - tomcat.install-tomcat-into-opt
  - apache

# Create Tomcat user and place
# into appropriate groups.
ui-host-tomcat-user:
  group.present:
    - name: tomcat
    - gid: 501
  user.present:
    - name: tomcat
    - uid: 501
    - groups:
      - cons3rt
      - tomcat
    - require:
      - group: ui-host-tomcat-user

ui-host-cons3rt-user:
  user.present:
    - name: cons3rt
    - groups:
      - apache

ui-host-packages:
  pkg.install:
    - names:
      - mod_ssl
      - php
      - php-curl
      - php-mysql
      - guacd
      - libguac-client-vnc
      - libguac-client-ssh
      - libguac-client-rdp

# Keep services alive
ui-host-services:
  service:
    - running
    - enable: True
    - names:
      - guacd
      - httpd

# Manage config files for:
# Apache
# mod_ssl
# PHP
ui-host-apache-conf:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://cons3rt/ui-host/templates/httpd.conf

ui-host-php-ini:
  file.managed:
    - name: /etc/php.ini
    - source: salt://cons3rt/ui-host/templates/php.ini

ui-host-mod-ssl-conf:
  file.managed:
    - name: /etc/httpd/conf.d/ssl.conf
    - source: salt://cons3rt/ui-host/templates/ssl.conf

# SELinux config
ui-host-selinux:
  selinux.boolean:
    - name: httpd_can_network_relay
    - value: True
    - persiste: True

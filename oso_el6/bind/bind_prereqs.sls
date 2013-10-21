bind-packages:
  pkg:
    - installed
    - names:
      - bind
      - bind-utils

dnssec-key-creation:
  cmd:
    - wait_script
    - name: dnssec-key-creation.sh
    - mode: 755
    - user: root
    - source: salt://oso_el6/bind/scripts/dnssec-key-creation.sh
    - template: jinja
    - watch:
      - pkg: bind-packages

rndc-key-creation:
  cmd:
    - wait
    - name: rndc-confgen -a -r /dev/urandom
    - watch:
      - pkg: bind-packages
  file:
    - managed
    - name: /etc/rndc.key
    - mode: 640
    - user: root
    - group: named
  
/var/named/forwarders.conf:
  file:
    - managed
    - source: salt://oso_el6/bind/templates/forwarders.conf.jinja
    - mode: 640
    - template: jinja

{% set oso_domain=salt['pillar.get']('oso_el6:domain','example.com') %}
initiate-dns-db:
  cmd:
    - wait
    - name: rm -rvf /var/named/dynamic && mkdir -vp /var/named/dynamic
    - watch:
      - pkg: bind-packages
  file:
    - managed
    - name: /var/named/dynamic/{{oso_domain}}.db
    - source: salt://oso_el6/bind/templates/named-dynamic-domain.db.jinja
    - template: jinja
    - user: named
    - group: named

dnssec-key-install:
  cmd:
    - wait_script
    - name: dnssec-key-install.sh
    - mode: 755
    - user: root
    - source: salt://oso_el6/bind/scripts/dnssec-key-install.sh
    - template: jinja
    - watch:
      - pkg: bind-packages

/etc/named.conf:
  file:
    - managed
    - source: salt://oso_el6/bind/templates/named.conf.jinja
    - template: jinja





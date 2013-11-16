include:
  - oso_el6.selinux.permissive

named-group:
  group:
    - present
    - name: named
    - gid: 25
    - system: True

named-user:
  user:
    - present
    - name: named
    - fullname: Named
    - shell: /sbin/nologin
    - home: /var/named
    - uid: 25
    - gid: 25
    - system: True
    - require:
      - group: named-group

bind-packages:
  pkg:
    - installed
    - names:
      - bind
      - bind-utils
    - require:
      - sls: oso_el6.selinux.permissive
      - user: named-user

dnssec-key-creation:
  cmd:
    - wait_script
    - name: dnssec-key-creation.sh
    - mode: 755
    - user: root
    - source: salt://oso_el6/bind/scripts/dnssec-key-creation.sh
    - template: jinja
    - watch:
      - file: /etc/named.conf

rndc-key-creation:
  cmd:
    - wait
    - name: rndc-confgen -a -r /dev/urandom
    - watch:
      - pkg: bind-packages
  file:
    - managed
    - name: /etc/rndc.key
    - mode: '0640'
    - user: root
    - group: named
  
/var/named/forwarders.conf:
  file:
    - managed
    - source: salt://oso_el6/bind/templates/forwarders.conf.jinja
    - user: named
    - group: named
    - mode: '0640'
    - template: jinja
 
remove-previous-dns-db:
  cmd:
    - wait
    - name: rm -rvf /var/named/dynamic && mkdir -vp /var/named/dynamic
    - watch:
      - pkg: bind-packages

initiate-dns-db:
  cmd:
    - wait_script
    - name: create-initial-dns-db.sh
    - user: root
    - mode: 755
    - source: salt://oso_el6/bind/scripts/create-initial-dns-db.sh
    - template: jinja
    - watch:
      - cmd: remove-previous-dns-db

{% set oso_domain=salt['pillar.get']('oso_el6:network:domain') %}
set-initial-dns-db-pems:
  file:
    - managed
    - name: /var/named/dynamic/{{oso_domain}}.db
    - user: named
    - group: named
    - mode: '0640'

dnssec-key-install:
  cmd:
    - wait_script
    - name: dnssec-key-install.sh
    - mode: 755
    - user: root
    - source: salt://oso_el6/bind/scripts/dnssec-key-install.sh
    - template: jinja
    - watch:
      - cmd: initiate-dns-db

/etc/named.conf:
  file:
    - managed
    - source: salt://oso_el6/bind/templates/named.conf.jinja
    - template: jinja
    - user: root
    - group: named


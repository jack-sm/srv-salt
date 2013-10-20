bind-packages:
  pkg:
    - installed
    - names:
      - bind
      - bind-utils

{% set dnssec_private_key=salt['pillar.get']('oso_el6:bind_keys:dnssec_private_key') %}
{% set dnssec_public_key=salt['pillar.get']('oso_el6:bind_keys:dnssec_public_key') %}
dnssec-key-management:
  file:
    - managed
    - name: /var/named/{{dnssec_private_key}}
    - source: salt://oso_el6/bind/keys/{{dnssec_private_key}}
  file:
    - managed
    - name: /var/named/{{dnssec_public_key}}
    - source: salt://oso_el6/bind/keys/{{dnssec_public_key}}

generate-rndc-key:
  cmd:
    - wait
    - name: rndc-confgen -a -r /dev/urandom
    - watch:
      - file: dnssec-key-management
  file:
    - managed
    - name: /etc/rndc.key
    - mode: 640
    - user: root
    - group: named

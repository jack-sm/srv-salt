#!/bin/bash
{% set oso_domain=salt['pillar.get']('oso_el6:network:domain') -%}
domain={{oso_domain}}
keyfile=/var/named/${domain}.key
KEY="$(grep Key: /var/named/K${domain}*.private | cut -d ' ' -f 2)"

cat << EOF > /etc/openshift/plugins.d/openshift-origin-dns-nsupdate.conf
BIND_SERVER="127.0.0.1"
BIND_PORT=53
BIND_KEYNAME="${domain}"
BIND_KEYVALUE="${KEY}"
BIND_ZONE="${domain}"
EOF

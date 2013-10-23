#!/bin/bash
{% set oso_domain=salt['pillar.get']('oso_el6:domain','example.com') %}
KEY="$(grep Key: /var/named/K{{oso_domain}}*.private | cut -d ' ' -f 2)"

cat <<EOF > /var/named/{{oso_domain}}.key
key {{oso_domain}} {
  algorithm HMAC-MD5;
  secret "${KEY}";
};
EOF


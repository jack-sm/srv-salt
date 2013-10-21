#!/bin/bash
domain={{salt['pillar.get']('oso_el6:domain','example.com')}}
KEY="$(grep Key: /var/named/K${domain}*.private | cut -d ' ' -f 2)"

cat <<EOF > /var/named/${domain}.key
key ${domain} {
  algorithm HMAC-MD5;
  secret "${KEY}";
};
EOF


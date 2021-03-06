#!/bin/bash

domain={{salt['pillar.get']('oso_el6:network:domain')}}

pushd /var/named
rm K${domain}*
dnssec-keygen -a HMAC-MD5 -b 512 -n USER -r /dev/urandom ${domain}
popd

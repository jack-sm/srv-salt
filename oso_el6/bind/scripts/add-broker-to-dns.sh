#!/bin/bash
{% set oso_domain=salt['pillar.get']('oso_el6:network:domain') %}
{% set oso_broker=salt['pillar.get']('oso_el6:broker:hostname') %}
{% set oso_broker_ip=salt['pillar.get']('oso_el6:broker:ip') %}
KEYFILE=/var/named/{{oso_domain}}.key
ECHO=$(which echo)
NSUPDATE=$(which nsupdate)

$ECHO "server 127.0.0.1" > /tmp/nsupdate
$ECHO "update delete {{oso_broker}}.{{oso_domain}}" >> /tmp/nsupdate
$ECHO "update add {{oso_broker}}.{{oso_domain}} 180 A {{oso_broker_ip}}" >> /tmp/nsupdate
$ECHO "send" >> /tmp/nsupdate

$NSUPDATE -k $KEYFILE -v /tmp/nsupdate 2>&1

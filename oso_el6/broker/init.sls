include:
  - oso_el6.broker.bind
  - oso_el6.broker.mongodb
  - oso_el6.iptables
  - oso_el6.network
  - oso_el6.ntp
  - oso_el6.yum_repositories
  - oso_el6.activemq
  - oso_el6.mcollective
  - oso_el6.selinux

oso-broker-packages:
  pkg:
    - installed
    - names:
      - openshift-origin-broker 
      - openshift-origin-broker-util
      - rubygem-openshift-origin-auth-remote-user 
      - rubygem-openshift-origin-auth-mongo
      - rubygem-openshift-origin-msg-broker-mcollective
      - rubygem-openshift-origin-dns-avahi
      - rubygem-openshift-origin-dns-nsupdate
      - rubygem-openshift-origin-dns-route53
      - ruby193-rubygem-passenger 
      - ruby193-mod_passenger
    - require:
      - sls: oso_el6.yum_repositories

{% for key in 'server_priv.pem', 'server_pub.pem', 'rsync_id_rsa', 'rsync_id_rsa.pub' %}
broker-key-{{key}}:
  file:
    - managed
    - name: /etc/openshift/{{key}}
    - source: salt://oso_el6/broker/keys/{{key}}
{% endfor %}


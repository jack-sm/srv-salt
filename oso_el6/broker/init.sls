include:
  - oso_el6.broker.prereqs
  - oso_el6.ruby193
  - oso_el6.bind
  - oso_el6.mongodb
  - oso_el6.iptables
  - oso_el6.network
  - oso_el6.ntp
  - oso_el6.yum_repositories
  - oso_el6.activemq
  - oso_el6.mcollective
  - oso_el6.selinux.permissive

oso-broker-packages:
  pkg:
    - installed
    - names:
      - openshift-origin-broker 
      - openshift-origin-broker-util
      - openshift-origin-console
      - rubygem-openshift-origin-auth-remote-user 
      - rubygem-openshift-origin-auth-mongo
      - rubygem-openshift-origin-msg-broker-mcollective
      - rubygem-openshift-origin-dns-bind
      - rubygem-openshift-origin-dns-nsupdate
      - rubygem-openshift-origin-dns-route53
      - ruby193-rubygem-passenger 
      - ruby193-mod_passenger
      - rubygem-openshift-origin-admin-console
{% if salt['pillar.get']('build','stable')=='nightly' %}
      - ruby193-openshift-origin-dns-avahi
{% endif %}
    - prereqs:
      - sls: oso_el6.broker.prereqs
      - sls: oso_el6.ruby193
      - sls: oso_el6.bind
      - sls: oso_el6.mongodb
      - sls: oso_el6.iptables
      - sls: oso_el6.network
      - sls: oso_el6.ntp
      - sls: oso_el6.yum_repositories
      - sls: oso_el6.activemq
      - sls: oso_el6.mcollective
    - require:
      - sls: oso_el6.selinux.permissive

configure-oso-nsupdate-plugin:
  cmd:
    - wait_script
    - name: configure-oso-dns-nsupdate.sh
    - source: salt://oso_el6/broker/scripts/configure-oso-dns-nsupdate.sh
    - template: jinja
    - require:
      - pkg: oso-broker-packages
    - watch:
      - pkg: oso-broker-packages

{% for key in 'server_priv.pem', 'server_pub.pem', 'rsync_id_rsa', 'rsync_id_rsa.pub' %}
broker-key-{{key}}:
  file:
    - managed
    - name: /etc/openshift/{{key}}
    - source: salt://oso_el6/broker/keys/{{key}}
{% endfor %}

/etc/openshift/broker.conf:
  file:
    - managed
    - source: salt://oso_el6/broker/templates/broker.conf.jinja
    - template: jinja
    - require:
       - pkg: oso-broker-packages

setup-selinux-context:
  module:
    - wait
    - name: state.sls
    - mods: oso_el6.selinux.enforcing
    - watch:
      - pkg: oso-broker-packages




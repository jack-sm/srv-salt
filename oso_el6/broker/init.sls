include:
  - oso_el6.broker.bind
  - oso_el6.broker.dhclient
  - oso_el6.network
  - oso_el6.ntp
  - oso_el6.yum_repositories
  - oso_el6.broker.mongodb
  - oso_el6.broker.activemq
  - oso_el6.broker.mcollective
  - oso_el6.broker.selinux

reboot-broker:
  cmd:
    - wait
    - name: /sbin/reboot --force
    - watch:
      - sls: oso_el6.broker.selinux

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



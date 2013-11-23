selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
  file:
    - managed
    - name: /etc/selinux/config
    - source: salt://oso_el6/selinux/templates/selinux-config

{% if grains['id']==salt['pillar.get']('oso_el6:broker:hostname') %}
oso-broker-selinux:
  cmd:
    - script
    - name: selinux-broker.sh
    - source: salt://oso_el6/selinux/scripts/selinux-broker.sh

{% elif grains['id']!=salt['pillar.get']('oso_el6:broker:hostname') %}
oso-node-selinux:
  cmd:  
    - script
    - name: selinux-node.sh
    - source: salt://oso_el6/selinux/scripts/selinux-node.sh

{% endif %}

include:
  - oso_el6.selinux.prereqs

selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
    - require:
      - sls: oso_el6.selinux.prereqs
  file:
    - managed
    - name: /etc/selinux/config
    - source: salt://oso_el6/selinux/templates/selinux-config
    - require:
      - sls: oso_el6.selinux.prereqs
      - selinux: oso-broker-selinux-booleans
      - cmd: oso-broker-selinux-fixfile

{% if grains['id']==salt['pillar.get']('oso_el6:broker:hostname') %}
oso-broker-selinux:
  cmd:
    - wait_script
    - name: selinux-broker.sh
    - source: salt://oso_el6/selinux/scripts/selinux-broker.sh
    - watch:
      - file: selinux-enforcing
    - require:
      - sls: oso_el6.selinux.prereqs

{% if grains['id']!=salt['pillar.get']('oso_el6:broker:hostname') %}
oso-node-selinux:
  cmd:  
    - wait_script
    - name: selinux-node.sh
    - source: salt://oso_el6/selinux/scripts/selinux-node.sh
    - watch:
      - file: selinux-enforcing
    - require:
      - sls: oso_el6.selinux.prereqs

{% endif %}



{% set cons3rtip=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['ip'] %}
{% set cons3rt=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['fqdn'] %}
{% set cons3rthome=salt['pillar.get']('cons3rt:cons3rt_path','/cons3rt') %}
include:
  - cons3rt.baseline.system-accounts

/net/{{cons3rt}}:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - mode: '0750'
    - makedirs: true
    - require:
      - sls: cons3rt.baseline.system-accounts

{% if grains['id']!=cons3rt %}
/net/{{cons3rt}}/cons3rt:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - mode: '0750'
    - makedirs: true
    - require:
      - sls: cons3rt.baseline.system-accounts

cons3rt-share-fstab-addition:
  file:
    - append
    - name: /etc/fstab
    - text: '{{cons3rtip}}:{{cons3rthome}} /net/{{cons3rt}}/cons3rt nfs defaults 0 0'

cons3rt-share-client-dependencies:
  pkg:
    - installed
    - name: nfs-utils

cons3rt-share-client:
  service:
    - name: netfs
    - running
    - enable: true
    - require:
      - pkg: cons3rt-share-client
  cmd:
    - wait
    - name: mount -a
    - watch:
      - service: cons3rt-share-client
    - require:
      - file: cons3rt-share-fstab-addition

restart-cons3rt-share-client:
  module:
    - wait
    - name: service.restart
    - m_name: netfs
    - watch:
      - pkg: cons3rt-share-client-dependencies
      - file: cons3rt-share-fstab-addition
      - file: /net/{{cons3rt}}/cons3rt
      - service: cons3rt-share-client
    - require:
      - service: cons3rt-share-client
      - cmd: cons3rt-share-client

{% elif grains['id']==cons3rt %}
cons3rt-share-symlink:
  file:
    - symlink
    - name: /net/{{cons3rt}}/cons3rt
    - target: {{cons3rthome}}

{% endif %}


{% set infratype=salt['pillar.get']('cons3rt-infrastructure:infrastructure_type','undefined') %}
{% set cons3rt=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['fqdn'] %}
{% set cons3rtip=() %}
{% if infratype|lower=='aws' %}
  {% set cons3rtip=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['private_ip'] %}
{% elif infratype|lower=='openstack' %}
  {% set cons3rtip=(salt['mine.get'](cons3rt,'network.ip_addrs'))[cons3rt]|first %}
{% else %}
  {% set cons3rtip=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['ip'] %}
{% endif %}
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

{% if cons3rtip is defined %}
cons3rt-share-fstab-addition:
  file:
    - append
    - name: /etc/fstab
    - text: '{{cons3rtip}}:{{cons3rthome}} /net/{{cons3rt}}/cons3rt nfs defaults 0 0'
{% endif %}

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
      - pkg: cons3rt-share-client-dependencies
  cmd:
    - wait
    - name: /bin/mount -o remount /net/{{cons3rt}}/cons3rt
    - watch:
      - service: cons3rt-share-client
    - require:
      - file: cons3rt-share-fstab-addition
      - service: cons3rt-share-client

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


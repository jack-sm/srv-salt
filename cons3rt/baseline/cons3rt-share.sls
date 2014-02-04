{% set cons3rtip=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['ip'] %}
{% set cons3rt=pillar['cons3rt-infrastructure']['hosts']['cons3rt']['hostname'] %}
/net/{{cons3rt}}:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - mode: '0750'
    - makedirs: true

{% if grains['id']!=cons3rt %}
/net/{{cons3rt}}/cons3rt:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - mode: '0750'
    - makedirs: true

cons3rt-share-fstab-addition:
  file:
    - append
    - name: /etc/fstab
    - text: '{{cons3rtip}}:/cons3rt /net/{{cons3rt}}/cons3rt nfs defaults 0 0'

cons3rt-share-client:
  pkg:
    - installed
    - name: nfs-utils

enable-cons3rt-share-client-service:
  service:
    - name: netfs
    - running
    - enable: true
    - require:
      - pkg: cons3rt-share-client

{% elif grains['id']==cons3rt %}
cons3rt-share-symlink:
  file:
    - symlink
    - name: /net/{{cons3rt}}/cons3rt
    - target: /cons3rt

{% endif %}


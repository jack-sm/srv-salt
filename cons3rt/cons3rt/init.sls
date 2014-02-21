{% set cons3rthome=salt['pillar.get']('cons3rt:cons3rt_path','/cons3rt') %}
{% set selinux = salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
include:
  - cons3rt.baseline
  - cons3rt.cons3rt.nfs
  - cons3rt.cons3rt.samba

{{cons3rthome}}:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - makedirs: true

{% for dir in 'agent-service','run' %}
{{cons3rthome}}/{{dir}}:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
    - makdirs: true
{% endfor %}

cons3rt-directory-default-acls:
  cmd:
    - wait
    - name: setfacl -m d:u::rwx,d:g::rwx,d:m:rwx,d:o:r-x {{cons3rthome}}
    - watch:
      - file: {{cons3rthome}}

cons3rt-file-server-services:
  service:
    - running
    - names:
      - nfs
      - rpcbind
      - smb
    - enable: true
    - require:
      - sls: cons3rt.cons3rt.samba
      - sls: cons3rt.cons3rt.nfs

{% if selinux|lower == 'true' %}
samba-selinux:
  cmd:
    - run
    - name: /usr/bin/chcon -R -t samba_share_t {{cons3rthome}}

nfs-selinux:
  cmd:
    - run
    - name: /usr/sbin/setsebool -P rsync_use_nfs 1
{% endif %}

restart-samba:
  module:
    - wait
    - name: service.restart
    - m_name: smb
    - watch:
      - sls: cons3rt.cons3rt.samba

{% for service in 'nfs','rpcbind' %}
restart-{{service}}:
  module:
    - wait
    - name: service.restart
    - m_name: {{service}}
    - watch:
      - sls: cons3rt.cons3rt.nfs
{% endfor %}


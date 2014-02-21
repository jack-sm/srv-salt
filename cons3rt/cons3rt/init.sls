{% set cons3rthome=salt['pillar.get']('cons3rt:cons3rt_path','/cons3rt') %}
{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
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
cons3rt-fileshare-selinux-validation:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/cons3rt-fileshare-setsebool-applied
    - makdirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\n/usr/sbin/setsebool -P rsync_use_nfs 1 and\n/usr/bin/chcon -R -t samba_share_t {{cons3rthome}} will be applied.\n"
    - user: root
    - group: root
    - mode: '0644'

samba-chcon-linux:
  cmd:
    - wait
    - name: /usr/bin/chcon -R -t samba_share_t {{cons3rthome}}
    - watch:
      - file: cons3rt-fileshare-selinux-validation

nfs-setsebool-selinux:
  cmd:
    - wait
    - name: /usr/sbin/setsebool -P rsync_use_nfs 1
    - watch:
      - file: cons3rt-fileshare-selinux-validation
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
{% if selinux|lower == 'true' %}
      - cmd: nfs-setsebool-selinux{% endfor %}
{% endfor %}


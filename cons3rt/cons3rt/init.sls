{% set cons3rthome=salt['pillar.get']('cons3rt:cons3rt_path','/cons3rt') %}
include:
  - cons3rt.baseline
  - cons3rt.cons3rt.nfs
  - cons3rt.cons3rt.samba

{% for dir in '{{cons3rthome}}','{{cons3rthome}}/agent-service','{{cons3rthome}}/run' %}
{{dir}}:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt
{% if dir == '{{cons3rthome}}' %}
    - mode: '2755'
{% endif %}
    - makdirs: true
{% endfor %}

cons3rt-directory-default-acls:
  cmd:
    - wait
    - name: setfacl -m d:u::rwx,d:g::rwx,d:m:rwx,d:o:r-x {{cons3rthome}}
    - watch:
      - file: /cons3rt

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


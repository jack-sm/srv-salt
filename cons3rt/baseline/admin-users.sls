{% set admins = salt['pillar.get']('cons3rt-administrators:administrators','undefined') %}
{% set admingroup = salt['pillar.get']('cons3rt-administrators:cons3rt_admin_group','cons3rt-administrators') %}
{% set admingid = salt['pillar.get']('cons3rt-administrators:cons3rt_admin_gid','510') %}
include:
  - cons3rt.baseline.system-accounts

cons3rt-administrators-group:
  group:
    - present
    - name: {{admingroup}}
    - gid: {{admingid}}
    - require:
      - sls: cons3rt.baseline.system-accounts

{% if adminusers != 'undefined' %}
{% for user in admins %}
cons3rt-admin-{{user}}:
  user:
    - present
    - name: {{user}}
    - groups:
      - {{admingroup}}
      - wheel
    - require:
      - group: cons3rt-administrators-group
      - sls: cons3rt.baseline.systems-accounts
{% if salt['pillar.get']('cons3rt-administrators:administrators:'~user~':ssh_key','undefined') != 'undefined' %}
  ssh_auth:
    - present
    - user: {{user}}
    - name: {{user.ssh_key}}
    - require:
      - user: cons3rt-admin-{{user}}
{% endif %}
{% endfor %}
{% endif %}


{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path') %}
commons-daemon:
  file:
    - managed
    - name: {{apps_path}}/commons-daemon/jsvc
    - source: salt://packages/commons-daemon/jsvc
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True



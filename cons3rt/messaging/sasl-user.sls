{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set sasl_password=pillar['cons3rt']['qpid_sasl_password'] %}
{% set qpid_sasldb=salt['pillar.get']('cons3rt:qpid_sasldb','/var/lib/qpidd/qpidd.sasldb') %}
include:
  - cons3rt.messaging.package

validate-sasl-user-creation:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/qpid-sasl-user-created
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

cons3rt-sasl-user:
  cmd:
    - wait
    - name: echo "{{sasl_password}}" | saslpasswd2 -pcf {{qpid_sasldb}} -u QPID -p cons3rt
    - watch:
      - file: validate-sasl-user-creation
    - require:
      - sls: cons3rt.messaging.package


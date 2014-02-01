{% set sasl_password=pillar['cons3rt']['qpid_sasl_password'] %}
{% set qpid_sasldb=salt['pillar.get']['cons3rt:qpid_sasldb_path','/var/lib/qpidd/qpidd.sasldb') %}
cons3rt-sasl-user:
  cmd:
    - run
    - name: echo "{{sasl_password}}" | saslpasswd2 -pcf {{qpid_sasldb}} -u QPID -p cons3rt



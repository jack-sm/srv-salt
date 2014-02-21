{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpid_version=pillar['cons3rt-packages']['qpid']['version'] %}
include:
  - cons3rt.messaging.package

{{apps_path}}/qpidd-{{qpid_version}}/etc/qpidd.conf:
  file:
    - managed
    - source: salt://cons3rt/messaging/templates/qpidd.conf.jinja
    - template: jinja
    - user: qpidd
    - group: qpidd
    - mode: '0644'
    - require:
      - sls: cons3rt.messaging.package

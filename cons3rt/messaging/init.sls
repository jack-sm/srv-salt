{% set qpidsaslauth = pillar['cons3rt']['qpid_use_sasl_auth'] %}
{% set qpidssl = pillar['cons3rt']['qpid_use_ssl_encryption'] %}
include:
  - cons3rt.baseline
  - cons3rt.messaging.package
  - cons3rt.messaging.messaging-profile
  - cons3rt.messaging.qpid-configuration
{% if qpidsaslauth|lower == 'true' %}
  - cons3rt.messaging.sasl-user
{% endif %}
{% if qpidssl|lower == 'true' %}
  - cons3rt.messaging.ssl
{% endif %}

cons3rt-messaging-services:
  service:
    - running
    - name: qpidd
    - enable: true
    - require:
      - sls: cons3rt.messaging.package
      - sls: cons3rt.messaging.qpid-configuration
      - sls: cons3rt.messaging.messaging-profile
{% if qpidsaslauth|lower == 'true' %}
      - sls: cons3rt.messaging.sasl-user
{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls. cons3rt.messaging.ssl
{% endif %}

restart-qpid:
  module:
    - wait
    - name: service.restart
    - m_name: qpidd
    - watch:
      - sls: cons3rt.messaging.package
      - sls: cons3rt.messaging.qpid-configuration
{% if qpidsaslauth|lower == 'true' %}
      - sls: cons3rt.messaging.sasl-user
{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls. cons3rt.messaging.ssl
{% endif %}


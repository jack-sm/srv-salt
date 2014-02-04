{% set qpidsaslauth = pillar['cons3rt']['qpid_use_sasl_auth'] %}
{% set qpidssl = pillar['cons3rt']['qpid_use_ssl_encryption'] %}
include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.messaging.package
{% if qpidsaslauth|lower == 'true' %}
  - cons3rt.messaging.sasl{% endif %}

cons3rt-messaging-services:
  service:
    - running
    - name: qpidd
    - enable: true
    - require:
      - sls: cons3rt.messaging.package
{% if qpidsaslauth|lower == 'true' %}
      - sls: cons3rt.messaging.sasl{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls. cons3rt.messaging.ssl{% endif %}

restart-qpid:
  module:
    - wait
    - name: service.restart
    - m_name: qpidd
    - watch:
      - sls: cons3rt.messaging.package
{% if qpidsaslauth|lower == 'true' %}
      - sls: cons3rt.messaging.sasl{% endif %}
{% if qpidssl|lower == 'true' %}
      - sls. cons3rt.messaging.ssl{% endif %}


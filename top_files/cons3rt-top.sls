# Aquire pillar values in order to attach roles to minions
{% set hosts = pillar['cons3rt-infrastructure']['hosts'] %}
{% set cons3rt = hosts.cons3rt.hostname %}
{% set database = hosts.database.hostname %}
{% set messaging = hosts.messaging.hostname %}
{% set assetrepository = hosts.assetrepository.hostname %}
{% set webinterface = hosts.webinterface.hostname %}
{% set sourcebuilder = hosts.sourcebuilder.hostname %}
{% set testmanager = hosts.testmanager.hostname %}
{% set retina = hosts.testmanager.hostname %}
{% set infrastructure = hosts.infrastructure.hostname %}
base:
  {{cons3rt}}:
    - cons3rt.cons3rt
{% if cons3rt == database %}
    - cons3rt.database{% endif %}
{% if cons3rt == messaging %}
    - cons3rt.messaging{% endif %}
{% if cons3rt == assetrepository %}
    - cons3rt.assetrepository{% endif %}
{% if cons3rt == sourcebuilder %}
    - cons3rt.sourcebuilder{% endif %}
{% if cons3rt == testmanager %}
    - cons3rt.testmanager{% endif %}
{% if cons3rt == infrastructure %}
    - cons3rt.infrastructure{% endif %}
{% if database != cons3rt and not null %}
  {{database}}:
    - cons3rt.database{% endif %}
{% if messaging != cons3rt %}
  {{messaging}}:
    - cons3rt.messaging{% endif %}
{% if assetrepository != cons3rt and not null %}
  {{assetrepository}}:
    - cons3rt.assetrepository{% endif %}
{% if sourcebuilder != cons3rt and not null %}
  {{sourcebuilder}}:
    - cons3rt.sourcebuilder{% endif %}
{% if testmanager != cons3rt and not null %}
  {{testmanager}}:
    - cons3rt.testmanager{% endif %}

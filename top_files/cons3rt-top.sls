base:
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:cons3rt:hostname','')}}:
    - cons3rt.cons3rt
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:database:hostname','')]}}:
    - cons3rt.database
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:messaging:hostname','')]}}:
    - cons3rt.messaging
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:assetrepository:hostname','')]}}:
    - cons3rt.assetrepository
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:webinterface::hostname','')]}}:
    - cons3rt.webinterface
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:sourcebuilder:hostname','')]}}:
    - cons3rt.sourcebuilder
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:testmanager:hostname','')]}}:
    - cons3rt.testmanager
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:retina:hostname','')]}}:
    - cons3rt.retina
  {{salt['pillar.get']('cons3rt-infrastructure:hosts:infrastructure:hostname','')]}}:
    - cons3rt.infrastructure

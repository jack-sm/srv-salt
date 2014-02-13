base:
  'role:*cons3rt*':
    - match: grain
    - cons3rt.cons3rt
  'role:*database*':
    - match: grain
    - cons3rt.database
  'role:*messaging*':
    - match: grain
    - cons3rt.messaging
  'role:*library*':
    - cons3rt.assetrepository
  'role:*sourcebuilder*':
    - cons3rt.sourcebuilder
  'role:*testmanager*':
    - cons3rt.testmanager
  'role:*infrastructure*':
    - cons3rt.infrastructure
  'role:*webinterface*':
    - cons3rt.infrastructure


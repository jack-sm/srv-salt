{%# This script is used for the initial otto configuration #%}

unpack-otto-archive:
  verify-otto-path:
    file.missing:
      - name: /root/bin/update_env

  /root/bin/update_env:
    file.directory:
      - user: root
      - group: root

  aquire-otto-archive:
    file.copy:
      - source: salt://cons3rt/files/{{pillar['cons3rt']['otto']['otto-package']}}
      - 


/cons3rt:
  file:
    - directory
    - user: cons3rt
    - group: cons3rt

aquire-cons3rt-package:
  file:
    - managed
    - name: /root/C
    - source: salt://packages/CONS3RT.tgz
    - user: root
    - group: root

unpack-cons3rt-package:
  cmd:
    - wait
    - name: tar xfz /root/CONS3RT.tgz -C /cons3rt
    - watch:
      - file: aquire-cons3rt-package

remove-cons3rt-package:
  file:
    - absent
    - name: /root/CONS3RT.tgz
    - require:
      - cmd: unpack-cons3rt-package

{% set version=pillar['cons3rt-packages']['version'] %}
/cons3rt/.cons3rt-{{version}}-installed:
  file:
    - managed
    - require:
      - file: remove-cons3rt-package

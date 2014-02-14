{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpid=pillar['cons3rt-packages']['cons3rt']['package'] %}
{% set qpid_version=pillar['cons3rt-packages']['cons3rt']['version'] %}
include:
  - cons3rt.baseline
  - cons3rt.environment

validate-cons3rt-package-deployment:
  file:
    - managed
    - name: {{apps_path}}/.saltstack-actions/cons3rt-package-{{cons3rtversion}}-deployed
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

aquire-cons3rt-package:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{cons3rt}}
    - dest: {{apps_path}}/{{cons3rt}}
    - watch:
      - file: validate-cons3rt-package-deployment

unzip-cons3rt-package:
  cmd:
    - wait
    - name: unzip -o {{apps_path}}/{{cons3rt}} -d {{apps_path}}/
    - watch:
      - file: aquire-cons3rt-package

untar-cons3rt-package:
  cmd:
    - wait
    - name: tar -zxf {{apps_path}}/CONS3RT-
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

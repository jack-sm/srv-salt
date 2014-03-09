{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpid=pillar['cons3rt-packages']['qpid']['package'] %}
{% set qpid_version=pillar['cons3rt-packages']['qpid']['version'] %}
qpid-dependencies:
  pkg:
    - installed
    - names:
      - boost
      - cyrus-sasl-plain
      - nss
      - nspr
      - compat-boost-filesystem
      - compat-boost-program-options

validate-qpid-server-installed:
  file:
    - managed
    - name:  {{apps_path}}/.saltstack-actions/qpid-version-{{qpid_version}}-deployed
    - makedirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\napache qpid {{qpid_version}} will be re-installed.\n"
    - user: root
    - group: root
    - mode: '0644'

aquire-qpid-archive:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{qpid}}
    - dest: {{apps_path}}/{{qpid}}
    - watch:
      - file: validate-qpid-server-installed

unpack-qpid-archive:
  cmd:
    - wait
    - name: tar -zxf {{qpid}}
    - cwd: {{apps_path}}/
    - watch:
      - module: aquire-qpid-archive

remove-qpid-archive:
  module:
    - wait
    - name: file.remove
    - path: {{apps_path}}/{{qpid}}
    - watch:
      - cmd: unpack-qpid-archive


{% for file in '/etc/qpidd.conf','/etc/init.d/qpidd' %}
remove-qpid-configurations-{{file}}:
  module:
    - wait
    - name: file.remove
    - path: {{file}}
    - watch:
      - module: remove-qpid-archive
{% endfor %}

# Set up symlinks for Qpid
{% set qpid_symlinks = [('/etc/qpidd.conf','qpidd.conf'),('/etc/init.d/qpidd','init.d/qpidd')] %}
{% for name,target in qpid_symlinks  %}
qpid-symlink-for-{{name}}:
  file:
    - symlink
    - name: {{name}}
    - target: {{apps_path}}/qpidd-{{qpid_version}}/etc/{{target}}
{% endfor %}


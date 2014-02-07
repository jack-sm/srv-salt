{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpid=pillar['cons3rt-packages']['qpid']['package'] %}
{% set qpid_version=pillar['cons3rt-packages']['qpid']['version'] %}
validate-qpid-server-installed:
  file:
    - managed
    - name:  {{apps_path}}/.saltstack-actions/qpid-version-{{qpid_version}}-deployed
    - makedirs: true
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

install-qpid-cpp-server-ssl:
  cmd:
    - wait
    - name: yum install -y qpid-cpp-server-ssl
    - watch:
      - module: remove-qpid-archive 

remove-qpid-cpp-server-ssl:
  cmd:
    - wait
    - name: yum erase -y qpid-cpp-server-ssl
    - watch:
      - cmd: install-qpid-cpp-server-ssl

{% for file in '/etc/qpidd.conf','/etc/init.d/qpidd' %}
remove-qpid-configurations-{{file}}:
  module:
    - wait
    - name: file.remove
    - path: {{file}}
    - watch:
      - cmd: remove-qpid-cpp-server-ssl
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

{{apps_path}}/qpidd-{{qpid_version}}:
  file:
    - directory
    - user: qpidd
    - group: qpidd
    - recurse:
      - user
      - group
    - require:
      - cmd: install-qpid-cpp-server-ssl



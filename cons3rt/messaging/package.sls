{% set apps_path=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set qpid=pillar['cons3rt-packages']['qpid']['package'] %}
{% set qpid_version=pillar['cons3rt-packages']['qpid']['version'] %}
install-qpid-cpp-server-ssl:
  file:
    - managed
    - name:  {{apps_path}}/.qpid-version-{{qpid_version}}-deployed
  cmd:
    - wait
    - name: yum install -y qpid-cpp-server-ssl
    - watch:
      - file: install-qpid-cpp-server-ssl

remove-qpid-cpp-server-ssl:
  cmd:
    - wait
    - name: yum erase -y qpid-cpp-server-ssl
    - watch:
      - cmd: install-qpid-cpp-server-ssl

remove-qpid-config-and-init:
  cmd:
    - wait
    - name: rm -rf /etc/qpidd.conf && rm -rf /etc/init.d/qpidd
    - watch:
      - cmd: remove-qpid-cpp-server-ssl

install-{{qpid}}:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{qpid}}
    - dest: {{apps_path}}/{{qpid}}
    - watch:
      - file: install-qpid-cpp-server-ssl
  cmd:
    - wait
    - name: tar -zxf {{qpid}}
    - cwd: {{apps_path}}/
    - watch:
      - module: install-{{qpid}}

remove-qpid-archive:
  module:
    - wait
    - name: file.remove
    - path: {{apps_path}}/{{qpid}}
    - watch:
      - cmd: install-{{qpid}}

# Set up symlinks for Qpid
{% set qpid_symlinks = [('/etc/qpidd.conf','qpidd.conf'),('/etc/init.d/qpidd','init.d/qpidd')] %}
{% for name,target in qpid_symlinks  %}
qpid-symlink-for-{{name}}:
  file:
    - symlink
    - name: {{name}}
    - target: {{apps_path}}/{{qpid|replace('.tar.gz','')}}/etc/{{target}}
{% endfor %}


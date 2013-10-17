# We need a newer version of Qpid but it's not in the repo.
# So we install the RPM of the old version to get the overhead,
# then remove it.
install-qpid-prereqs:
  cmd.run:
    - name: yum install -y qpid-cpp-server-ssl
  cmd.wait:
    - name: yum erase -y qpid-cpp-server-ssl
    - wait:
      - cmd: install-qpid-prereqs

# Install Qpid from a tarball
# NOTE: We need to acquire the Qpid tarball
install-qpid:
  file.managed:
    - name: /opt/qpid.tar.gz
    - source: salt://qpid/qpid.tar.gz
  cmd.wait:
    - name: tar -zxvf qpid.tar.gz
    - cwd: /opt/
    - wait:
      - file: install-qpid
     
# Set up symlinks for Qpid
{% set qpid_symlinks = [
  ('/etc/qpidd.conf','qpidd.conf'),
  ('/etc/init.d/qpidd','init.d/qpidd')
]  %}
{% for name,target in qpid_symlinks  %}
qpid-symlink-for-{{link}}:
  file.symlink:
    - name: {{name}}
    - target: /opt/qpidd-0.22/etc/{{target}}
{% endfor %}

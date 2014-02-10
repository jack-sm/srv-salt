/etc/security/limits.d/99-qpidd.conf:
  file:
    - managed
    - contents: "@qpidd soft nofile 10240/n@qpidd hard nofile 65535/n"
    - user: root
    - group: root
    - mode: '0644'

{% if salt['pillar.get']('cons3rt-infrastructure:enabled_selinux','false')|lower == 'true' %}
chcon-file-descriptors-qpidd:
  cmd:
    - run
    - name: chcon -u system_u /etc/security/limits.d/99-qpid.conf
{% endif %}


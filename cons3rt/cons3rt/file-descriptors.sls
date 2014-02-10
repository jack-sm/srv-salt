/etc/security/limits.d/99-cons3rt.conf:
  file:
    - managed
    - contents: "cons3rt soft nofile 4096/ncons3rt hard nofile 10240/n"
    - user: root
    - group: root
    - mode: '0644'

/etc/security/limits.d/99-root.conf:
  file:
    - managed
    - contents: "root soft nofile 4096/nroot hard nofile 10240/n"
    - user: root
    - group: root
    - mode: '0644'

{% if salt['pillar.get']('cons3rt-infrastructure:enabled_selinux','false')|lower == 'true' %}
{% for file in 'root','cons3rt' %}
chcon-file-descriptors-{{file}}:
  cmd:
    - run
    - name: chcon -u system_u /etc/security/limits.d/99-{{file}}.conf
{% endfor %}{% endif %}


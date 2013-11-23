include:
  - oso_el6.bind.prereqs

named:
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - sls: oso_el6.bind.prereqs
    - watch:
      - sls: oso_el6.bind.prereqs

named-dir-perms:
  file:
    - directory
    - name: /var/named
    - user: named
    - group: named
    - dir_mode: '0750'
    - file_mode: '0640'
    - recurse:
      - user
      - group
      - mode
    - require:
      - sls: oso_el6.bind.prereqs

add-broker-to-dns:
  cmd:
    - wait_script
    - name: add-broker-to-dns.sh
    - user: root
    - mode: '0755'
    - source: salt://oso_el6/bind/scripts/add-broker-to-dns.sh
    - template: jinja
    - require:
      - sls: oso_el6.bind.prereqs
    - watch:
      - file: /var/named

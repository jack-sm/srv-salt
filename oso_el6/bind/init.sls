include:
  - oso_el6.bind.prereqs

named:
  service:
    - running
    - enable: True
    - require:
      - sls: oso_el6.bind.prereqs

/var/named:
  file:
    - directory
    - user: named
    - group: named
    - dir_mode: 750
    - file_mode: 640
    - recurse:
      - user
      - group
      - mode

add-broker-to-dns:
  cmd:
    - script
    - name: add-broker-to-dns.sh
    - user: root
    - mode: 755
    - source: salt://oso_el6/bind/scripts/add-broker-to-dns.sh
    - template: jinja
    - require:
      - service: named

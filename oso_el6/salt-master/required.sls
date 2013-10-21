oso_el6-management-pkgs:
  pkg:
    - installed
    - name:
      - dnssec-utils
      - python-augeas

dnssec-key-creation:
  cmd:
    - wait_script
    - name: dnssec-key-creation.sh
    - source: salt://oso_el6/salt-master/dnssec-key-creation.sh
    - template: jinja
    - watch:
      - pkg: oso_el6-management-pkgs


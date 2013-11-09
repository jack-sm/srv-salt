selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
  file:
    - managed
    - name: /etc/selinux/config
    - source: salt://oso_el6/selinux/templates/selinux-config

selinux-management-pkgs:
  pkg:
    - installed
    - names:
      - policycoreutils
      - policycoreutils-python
    
oso-broker-selinux-booleans:
  selinux:
    - boolean
    - names:
      - httpd_unified
      - httpd_can_network_connect
      - httpd_can_network_relay 
      - httpd_run_stickshift 
      - named_write_master_zones 
      - allow_ypbind
      - httpd_verify_dns 
      - httpd_enable_homedirs
      - httpd_execmem
    - value: on
    - persist: True
    - require:
      - pkg: selinux-management-pkgs

oso-broker-selinux-fixfile:
  cmd:
    - wait
    - names:
      - fixfiles -R ruby193-rubygem-passenger restore
      - fixfiles -R ruby193-mod_passenger restore
      - restorecon -rv /var/run
    - watch:
      - selinux: selinux-enforcing

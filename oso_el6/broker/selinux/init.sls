enforcing:
  selinux:
    - mode

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
    - value: True
    - persist: True

correct-selinux-context:
  cmd:
    - wait
    - names:
      - fixfiles -R ruby193-rubygem-passenger restore
      - fixfiles -R ruby193-mod_passenger restore
      - restorecon -rv /var/run
    - watch:
      - selinux: oso-broker-selinux-booleans

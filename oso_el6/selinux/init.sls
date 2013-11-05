broker-selinux-enforcing:
  selinux:
    - mode
    - name: enforcing
  file:
    - replace
    - name: /etc/selinux/config
    - pattern: SELINUX=permissive
    - repl: SELINUX=enforcing

oso-broker-selinux-prereqs:
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
  cmd:
    - wait
    - names:
      - fixfiles -R ruby193-rubygem-passenger restore
      - fixfiles -R ruby193-mod_passenger restore
      - restorecon -rv /var/run
      - /sbin/reboot --force
    - watch:
      - selinux: broker-selinux-enforcing
      - file: broker-selinux-enforcing

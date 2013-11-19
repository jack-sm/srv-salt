(
  # Allow console application to access executable and writable memory
  echo boolean -m --on httpd_execmem
  
  # Allow the broker to write files in the http file context.
  echo boolean -m --on httpd_unified
  
  # Allow the broker and console to access the network.
  echo boolean -m --on httpd_can_network_connect
  echo boolean -m --on httpd_can_network_relay
  
  # Enable some passenger-related permissions.
  #
  # The name may change at some future point, at which point we will
  # need to delete the httpd_run_stickshift line below and enable the
  # httpd_run_openshift line.
  echo boolean -m --on httpd_run_stickshift
  #echo boolean -m --on httpd_run_openshift
  
  # Allow the broker to communicate with the named service.
  echo boolean -m --on allow_ypbind
  
  
  echo boolean -m --on httpd_verify_dns
  echo boolean -m --on httpd_read_user_content
  echo boolean -m --on httpd_enable_homedirs
  
  echo fcontext -a -t httpd_var_run_t '/var/www/openshift/broker/httpd/run(/.*)?'
  echo fcontext -a -t httpd_tmp_t '/var/www/openshift/broker/tmp(/.*)?'
  echo fcontext -a -t httpd_log_t '/var/log/openshift/broker(/.*)?'
  
  echo fcontext -a -t httpd_log_t '/var/log/openshift/console(/.*)?'
  echo fcontext -a -t httpd_log_t '/var/log/openshift/console/httpd(/.*)?'
  echo fcontext -a -t httpd_var_run_t '/var/www/openshift/console/httpd/run(/.*)?'
) | semanage -i -

chcon -R -t httpd_log_t /var/log/openshift/broker
chcon -R -t httpd_tmp_t /var/www/openshift/broker/httpd/run
chcon -R -t httpd_var_run_t /var/www/openshift/broker/httpd/run

fixfiles -R ruby193-rubygem-passenger restore
fixfiles -R ruby193-mod_passenger restore
fixfiles -R rubygem-passenger restore
fixfiles -R mod_passenger restore

restorecon -rv /var/run
restorecon -rv /opt
restorecon -rv /var/www/openshift/broker/tmp
restorecon -v '/var/log/openshift/broker/user_action.log'
restorecon -R /var/log/openshift/console
restorecon -R /var/www/openshift/console

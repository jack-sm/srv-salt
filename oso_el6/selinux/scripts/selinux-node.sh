(
  # Allow the node to write files in the http file context.
  echo boolean -m --on httpd_unified

  # Allow the node to access the network.
  echo boolean -m --on httpd_can_network_connect
  echo boolean -m --on httpd_can_network_relay

  # Allow httpd on the node to read gear data.
  #
  # The name may change at some future point, at which point we will
  # need to delete the httpd_run_stickshift line below and enable the
  # httpd_run_openshift line.
  echo boolean -m --on httpd_run_stickshift
  #echo boolean -m --on httpd_run_openshift
  echo boolean -m --on httpd_read_user_content
  echo boolean -m --on httpd_enable_homedirs

  # Enable polyinstantiation for gear data.
  echo boolean -m --on allow_polyinstantiation
  
  echo boolean -m --on httpd_execmem
) | semanage -i -

restorecon -rv /var/run
restorecon -rv /var/lib/openshift /etc/openshift/node.conf

#!/bin/bash

setsebool -P  httpd_unified=on httpd_can_network_connect=on httpd_can_network_relay=on \
              httpd_run_stickshift=on named_write_master_zones=on allow_ypbind=on \
              httpd_verify_dns=on httpd_enable_homedirs=on httpd_execmem=on

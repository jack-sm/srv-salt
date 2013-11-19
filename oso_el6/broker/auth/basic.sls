/etc/openshift/htpasswd:
  file:
    - present

set-first-oso-user:
  cmd:
    - wait
    - name: /usr/bin/htpasswd -b /etc/openshift/htpasswd {{pillar['oso_el6']['broker']['initial_user']}} {{pillar['oso_el6']['initial_user_password']}}
    - watch:
      - file: /etc/openshift/htpasswd
    - require:
      - file: /etc/openshift/htpasswd


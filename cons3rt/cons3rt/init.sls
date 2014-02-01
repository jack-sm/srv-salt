include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.cons3rt.nfs
  - cons3rt.cons3rt.samba

cons3rt-file-server-services:
  service:
    - running
    - names:
      - nfs
      - rpcbind
      - smb
    - enable: true
    - require:
      - sls: cons3rt.cons3rt.samba
      - sls: cons3rt.cons3rt.nfs



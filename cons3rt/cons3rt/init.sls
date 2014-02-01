include:
  - cons3rt.baseline:
    - commons-daemon
    - cons3rt-profile
    - cons3rt-share
    - system-accounts
    - iptables
    - ntp
    - java-jre
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



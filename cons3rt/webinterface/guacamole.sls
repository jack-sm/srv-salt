guacamole-packages:
  pkg:
    - installed
    - names:
      - guacd
      - libguac-client-vnc
      - libguac-client-ssh
      - libguac-client-rdp

guacd:
  service:
    - running
    - enable: True


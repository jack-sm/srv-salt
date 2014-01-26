guacamole-packages:
  pkg:
    - installed
    - name:
      - guacd
      - libguac-client-vnc
      - libguac-client-ssh
      - libguac-client-rdp

guacd:
  service:
    - running
    - enable: True


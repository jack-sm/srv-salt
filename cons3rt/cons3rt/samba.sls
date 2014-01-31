/etc/samba/smb.conf:
  file:
    - managed
    - source: salt://cons3rt/cons3rt/templates/smb.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

samba:
  pkg:
    - installed

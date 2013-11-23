selinux-management-pkgs:
  pkg:
    - installed
    - names:
      - policycoreutils
      - policycoreutils-python

permissive:
  selinux:
    - mode
    - require:
      - pkg: policycoreutils
      - pkg: policycoreutils-python

force-selinux-permissive:
  cmd:
    - wait
    - name: /usr/sbin/setenforce permissive
    - user: root
    - watch:
      - selinux: permissive

/etc/ssh/sshd_config:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/{{grains['os']|lower}}_sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

restart-sshd:
  module:
    - wait
    - name: service.restart
    - m_name: sshd
    - watch:
      - file: /etc/ssh/sshd_config

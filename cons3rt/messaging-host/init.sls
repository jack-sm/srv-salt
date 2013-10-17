jpmsg-user-and-group:
  group.present:
    - name: jpmsg
    - gid: 501
  user.present:
    - name: jpmsg
    - uid: 501
    - home: /cons3rt/jackpine-messaging
    - groups:
      - jpmsg
      - cons3rt
    - require:
      group: jpmsg-user-and-group

cons3rt-sasl:
  file.installed:
    - name: cyrus-sasl-plain

manage-cons3rt-qpid:
  file.managed:
    - name: /opt/qpidd-0.20/etc/qpidd.conf
    - source: salt://qpid/cons3rt-ui-host-qpidd.conf
  service:
    - running
    - name: qpidd
    - enable: True
    - watch:
      - file: manage-cons3rt-qpid

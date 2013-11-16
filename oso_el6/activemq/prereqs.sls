include:
  - oso_el6.yum_repositories
  - oso_el6.selinux.permissive

activemq-group:
  group:
    - present
    - name: activemq
    - gid: 498
    - system: True

activemq-user:
  user:
    - present
    - name: activemq
    - fullname: Apache Activemq
    - shell: /bin/bash
    - home: /usr/share/activemq
    - uid: 498
    - gid: 498
    - system: True
    - require:
      - group: activemq-group

activemq-broker-packages:
  pkg:
    - installed
    - names:
      - activemq
      - activemq-client
    - prereqs:
      - sls: oso_el6.selinux.permissive
    - require:
      - sls: oso_el6.yum_repositories
      - user: activemq-user

/etc/activemq/activemq.xml:
  file:
    - managed
    - source: salt://oso_el6/activemq/templates/activemq.xml.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: activemq-broker-packages

/etc/activemq/jetty.xml:
  file:
    - managed
    - source: salt://oso_el6/activemq/templates/jetty.xml
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: activemq-broker-packages

/etc/activemq/jetty-realm.properties:
  file:
    - managed
    - source: salt://oso_el6/activemq/templates/jetty-realm.properties.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: activemq-broker-packages

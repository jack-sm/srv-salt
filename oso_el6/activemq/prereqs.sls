include:
  - oso_el6.yum_repositories
  - oso_el6.selinux

activemq-broker-packages:
  pkg:
    - installed
    - names:
      - activemq
      - activemq-client
    - require:
      - sls: oso_el6.yum_repositories
      - sls: oso_el6.selinux

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


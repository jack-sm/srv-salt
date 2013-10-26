include:
  - oso_el6.yum_repositories

activemq-broker-packages:
  pkg:
    - installed
    - names:
      - activemq
      - activemq-client
    - require:
      - sls: oso_el6.yum_repositories

/etc/activemq/activemq.xml:
  file:
    - managed
    - source: salt://oso_el6/broker/activemq/templates/activemq.xml.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/activemq/jetty.xml:
  file:
    - managed
    - source: salt://oso_el6/broker/activemq/templates/jetty.xml
    - user: root
    - group: root
    - mode: 644

/etc/activemq/jetty-realm.properties:
  file:
    - managed
    - source: salt://oso_el6/broker/activemq/templates/jetty-realm.properties.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644


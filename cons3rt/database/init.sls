include:
{% for state in 'commons-daemon','commons-daemon','cons3rt-profile','cons3rt-share
','system-accounts','iptables','ntp','java-jre','packages' %}
  - cons3rt.baseline.{{state}}{% endfor %}
  - cons3rt.database.mysql.packages
  - cons3rt.database.mysql.database-credentials
  - cons3rt.database.mysql.grants
 
mysqld:
  service:
    - running
    - enable: true
    - require:
      - sls: cons3rt.database.mysql.packages 

cons3rt-database-service:
  module:
    - wait
    - name: service.restart
    - m_name: mysqld
    - watch:
      - sls: cons3rt.database.mysql.packages


{% set jre=salt['pillar.get']('cons3rt-packages:java_jre:version','') %}
{% set jrepackage=salt['pillar.get']('cons3rt-packages:java_jre:package','') %}
{% set jrepath=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
validate-java-jre-installed:
  file:
    - managed
    - name: {{jrepath}}/.java-jre-version-{{jre}}-installed
    - user: root
    - group: root
    - mode: '0644'

java-jre-package:
  file:
    - managed
    - source: salt://cons3rt/packages/{{jrepackage}}
    - name: {{jrepath}}/{{jrepackage}}
  cmd:
    - wait
    - cwd: {{jrepath}}/.
    - name: tar -zxf {{jrepath}}/{{jrepackage}}
    - watch:
      - file: validate-java-jre-installed
  alternatives:
    - install
    - name: java
    - link: /usr/bin/java
    - path: {{jrepath}}/jre{{jre}}/bin/java
    - priority: 1
    - require:
      - cmd: java-jre-package

/etc/profile.d/java.sh:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/jre-java.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - cmd: java-jre-package


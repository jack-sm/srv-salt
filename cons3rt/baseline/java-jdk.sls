{% set jdkversion=salt['pillar.get']('cons3rt-packages:java-jdk:version','') %}
{% set jdkpackage=salt['pillar.get']('cons3rt-packages:java-jdk:package','') %}
{% set jdkpath=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
oracle-jdk-package:
  file:
    - managed
    - source: salt://cons3rt/packages/{{jdkpackage}}
    - name: {{jdkpath}}/jdk.tar.gz
  cmd:
    - wait
    - cwd: {{jdkpath}}/.
    - name: tar -zxvf {{jdkpath}}/jdk.tar.gz
    - watch:
      - file: oracle-jdk-package

{% set jdkversion=salt['pillar.get']('cons3rt-packages:jdk-version','') %}
{% set jdkpath=salt['pillar.get']('oracle-java:jdk-path','/opt') %}
oracle-jdk-alternatives:
  alternatives:
    - install
    - name: java
    - link: /usr/bin/java
    - path: {{jdkpath}}/{{jdkversion}}
    - priority: 1
    - require:
      - cmd: oracle-jdk-package

/etc/profile.d/java.sh:
  file:
    - managed
    - source: salt://java/templates/jdk-java.sh.jinja
    - template: jinja
    - require:
      - cmd: oracle-jdk-package


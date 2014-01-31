{% set jdk=salt['pillar.get']('cons3rt-packages:java_jdk:version','') %}
{% set jdkpackage=salt['pillar.get']('cons3rt-packages:java_jdk:package','') %}
{% set jdkpath=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
validate-java-jdk-installed:
  file:
    - managed
    - name: {{jdkpath}}/.java-jdk-version-{{jdk}}-deployed
    - user: root
    - group: root
    - mode: '0644'

deploy-java-jdk-package:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{jdkpackage}}
    - dest: {{jdkpath}}/{{jdkpackage}}
    - watch:
      - file: validate-java-jdk-installed
  cmd:
    - wait
    - cwd: {{jdkpath}}/.
    - name: tar -zxf {{jdkpath}}/{{jdkpackage}}
    - watch:
      - module: deploy-java-jdk-package
  alternatives:
    - install
    - name: java
    - link: /usr/bin/java
    - path: {{jdkpath}}/jdk{{jdk}}/bin/java
    - priority: 1
    - require:
      - cmd: deploy-java-jdk-package

remove-java-jdk-archive:
  module:
    - wait
    - name: file.remove
    - path: {{jdkpath}}/{{jdkpackage}}
    - watch:
      - cmd: deploy-java-jdk-package

/etc/profile.d/java.sh:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/jdk-java.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - cmd: deploy-java-jdk-package

{{jdkpath}}/jdk{{jdk}}:
  file:
    - directory
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd: deploy-java-jdk-package

{% set jre=salt['pillar.get']('cons3rt-packages:java_jre:version','') %}
{% set jrepackage=salt['pillar.get']('cons3rt-packages:java_jre:package','') %}
{% set jrepath=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set selinux = salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
validate-java-jre-installed:
  file:
    - managed
    - name: {{jrepath}}/.saltstack-actions/java-jre-version-{{jre}}-deployed
    - makedirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\noracle-java-jre verion {{jre}} will be re-installed.\n"
    - user: root
    - group: root
    - mode: '0644'

deploy-java-jre-package:
  module:
    - wait
    - name: cp.get_file
    - path: salt://cons3rt/packages/{{jrepackage}}
    - dest: {{jrepath}}/{{jrepackage}}
    - watch:
      - file: validate-java-jre-installed
  cmd:
    - wait
    - cwd: {{jrepath}}/.
    - name: tar -zxf {{jrepath}}/{{jrepackage}}
    - watch:
      - module: deploy-java-jre-package
  alternatives:
    - install
    - name: java
    - link: /usr/bin/java
    - path: {{jrepath}}/jre{{jre}}/bin/java
    - priority: 1
    - require:
      - cmd: deploy-java-jre-package

remove-java-jre-archive:
  module:
    - wait
    - name: file.remove
    - path: {{jrepath}}/{{jrepackage}}
    - watch:
      - cmd: deploy-java-jre-package

/etc/profile.d/java.sh:
  file:
    - managed
    - source: salt://cons3rt/baseline/templates/jre-java.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - cmd: deploy-java-jre-package

{{jrepath}}/jre{{jre}}:
  file:
    - directory
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd: deploy-java-jre-package

{% if selinux|lower == 'true' %}
java-jre-selinux:
  cmd:
    - run
    - name: /usr/bin/chcon -t textrel_shlib_t {{jrepath}}/jre{{jre}}/lib/amd64/server/libjvm.so
{% endif %}



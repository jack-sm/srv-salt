{% set cacert=salt['pillar.get']('cons3rt:ca_certificate_filename') %}
{% set cacertalias=salt['pillar.get']('cons3rt:ca_certificate_alias') %}
{% set jre=salt['pillar.get']('cons3rt-packages:java_jre:version','') %}
{% set jrepackage=salt['pillar.get']('cons3rt-packages:java_jre:package','') %}
{% set jrepath=salt['pillar.get']('cons3rt-packages:application_path','/opt') %}
{% set selinux=salt['pillar.get']('cons3rt-infrastructure:enable_selinux','false') %}
/etc/pki/tls/certs/{{cacert}}:
  file:
    - managed
    - source: salt://cons3rt/tls/{{cacert}}
    - user: root
    - group: root
    - mode: '0644'

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
    - mode: '0755'
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

{% if salt['file.file_exits']({{jrepath}}~'/jre'~{{jre}}~'/lib/security/cacerts') == true %}
validate-cacert-injected-java-keystore:
  file:
    - managed
    - name: {{jrepath}}/.saltstack-actions/java-jre-version-{{jre}}-cacert-injected
    - makedirs: true
    - contents: "SALTSTACK LOCK FILE\nIf the contents or permissions of this file are changed in any way,\nsaltstack will attempt to inject the cacert into the default\njava keystore.\n"
    - user: root
    - group: root
    - mode: '0644'

inject-cacert-java-keystore:
  cmd:
    - wait
    - name: {{jrepath}}/jre{{jre}}/bin/keytool -import -noprompt -file /etc/pki/tls/certs/{{cacert}} -alias {{cacertalias}} -keystore {{jrepath}}/jre{{jre}}/lib/security/cacerts -storepass changeit
    - watch:
      - file: validate-cacert-injected-java-keystore
    - require:
      - file: /etc/pki/tls/certs/{{cacert}}
{% endif %}
  
{% if selinux|lower == 'true' %}
java-jre-selinux:
  cmd:
    - run
    - name: /usr/bin/chcon -t textrel_shlib_t {{jrepath}}/jre{{jre}}/lib/amd64/server/libjvm.so
{% endif %}



## NOTE: This was written for Salt 0.16.4, hence all the requisite
## statements. Salt 0.17 introduces sequential execution of states.
## This means that once we upgrade to Salt 0.17, we can remove
## all the requisite statements.

# NOTE: This is just a copy of the JRE install. We need to find a more
# concise way of offering JDK and JRE insalls...
drop-jdk-tarball:
  file.managed:
    - source: salt://{{pillar.get('cons3rt:files:jdk-location')}}
    - name: /opt/jdk.tar.gz

unpack-jdk-tarball:
  cmd.wait:
    - cwd: /opt/.
    - name: tar -zxvf /opt/jdk.tar.gz
    - watch:
      - file: drop-jdk-tarball

update-jdk-alternatives:
  cmd.wait:
    - name: "updatedb && update-alternatives --install /usr/bin/java java /opt/{{salt['pillar.get']('cons3rt:files:jdk-version')}}/bin/java 1"
    - wait:
      - cmd: unpack-jdk-tarball

drop-jdk-java.sh:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://java/files/jdk-java.sh.jinja
    - template: jinja
    - wait:
      - cmd: update-jdk-alternatives


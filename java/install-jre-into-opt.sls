## NOTE: This was written for Salt 0.16.4, hence all the requisite
## statements. Salt 0.17 introduces sequential execution of states.
## This means that once we upgrade to Salt 0.17, we can remove
## all the requisite statements.

## NOTE(2): We need a sustainable way forward re: how to pull out pillar values

drop-jre-tarball:
  file.managed:
    - source: salt://{{pillar.get('cons3rt:files:jre-location')}}
    - name: /opt/jre.tar.gz

unpack-jre-tarball:
  cmd.wait:
    - cwd: /opt/.
    - name: tar -zxvf /opt/jre.tar.gz
    - watch:
      - file: drop-jre-tarball

update-jre-alternatives:
  cmd.wait:
    - name: "updatedb && update-alternatives --install /usr/bin/java java /opt/{{salt['pillar.get']('cons3rt:files:jre-version')}}/bin/java 1"
    - wait:
      - cmd: unpack-jre-tarball

drop-jre-java.sh:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://java/files/jre-java.sh.jinja
    - template: jinja
    - wait:
      - cmd: update-jre-alternatives


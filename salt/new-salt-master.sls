{% for package in 'salt-master','git','GitPython','vim' %}
salt-master-install-{{package}}:
  pkg.installed:
    - name: {{package}}
{%endfor%}


#upgrade-to-salt-17:
#  cmd.script:
#    - source: salt://salt/files/upgrade-salt-from-github.sh
#    - wait:
#      - pkg: salt-master

add-salt-vim-files:
  cmd.script:
    - source: salt://salt/files/install-salt-vim-files.sh

add-external-backends:
  file.managed:
    - name: /etc/salt/master.d/add-external-backends.conf
    - source: salt://salt/files/add-external-backends.conf
    - mkdirs: True

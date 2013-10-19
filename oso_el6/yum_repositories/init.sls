el6-openshift-deps-repo:
  file:
    - managed
    - name: /etc/yum.repos.d/openshift-origin-deps.repo
    - source: salt://oso_el6/yum_repositories/files/openshift-origin-deps.repo.jinja
    - template: jinja

openshift-el6-repo:
  file:
    - managed
    - name: /etc/yum.repos.d/openshift-origin.repo
    - source: salt://oso_el6/yum_repositories/files/openshift-origin.repo.jinja
    - template: jinja

epel6-repo:
  file:
    - managed
    - name: /etc/yum.repos.d/epel6-oso.repo
    - source: salt://oso_el6/yum_repositories/files/epel6-oso.repo

epel6-gpg-key:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
    - source: salt://oso_el6/yum_repositories/files/RPM-GPG-KEY-EPEL-6
    - mode: '0644'


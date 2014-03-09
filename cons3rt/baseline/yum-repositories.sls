retrieve-centos-gpg-key:
  cmd:
    - run
    - name: /usr/bin/wget -N http://mirror.centos.org/centos/6/os/x86_64/RPM-GPG-KEY-CentOS-6
    - cwd: /etc/pki/rpm-gpg

/etc/yum.repos.d/el6.repo
  file:
    - managed
    - contents: "[el6-base]\nname=EL6-Base\nbaseurl=http://mirror.centos.org/centos/6/os/x86_64/\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6\n\n[el6-updates]\nname=EL6-Updates\nbaseurl=http://mirror.centos.org/centos/6/os/x86_64/\ngpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6\n"
    - user: root
    - group: root
    - mode: '0644'


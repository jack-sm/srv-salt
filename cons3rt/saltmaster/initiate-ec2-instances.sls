{% set infratype=pillar['cons3rt-infrastructure']['infrastructure_type'] %}
{% if infratype|lower=='aws' %}
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% set keyname=pillar['aws-credentials']['key_name'] %}
{% set secgroup=pillar['aws-credentials']['security_group_id'] %}
{% set subnet=pillar['aws-credentials']['subnet_id'] %}
{% set saltminionpub=() %}
{% set saltminionpem=() %}
{% set saltminion=() %}
/home/ec2-user/launched-aws-instances:
  file:
    - directory
    - makedir: true

{% for host, value in hosts.iteritems() %}
{% if value['fqdn'] is defined and value['fqdn']|lower!='none' %}{% if launched is defined %}{% if value['fqdn'] not in launched %}
{% do launched.append(value['fqdn']) %}
aws-instance-{{value['fqdn']}}:
  file:
    - managed
    - file: /root/launched-aws-instances/{{value['fqdn']}}
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

create-salt-minion-keys:
  cmd:
    - wait
    - name: salt-key --gen-keys={{value['fqdn']}}
    - cwd: /etc/salt/pki/master/minions
    - watch:
      - file: aws-instance-{{value['fqdn']}}

{% set saltminionpub=salt['cmd.run']('cat /etc/salt/master/minions/'~value['fqdn']~'.pub') %}
{% set saltminionpem=salt['cmd.run']('cat /etc/salt/master/minions/'~value['fqdn']~'.pem') %}

create-instance-bootstrap-{{value['fqdn']}}:
  file:
    - managed
    - file: /home/ec2-user/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh
    - source: salt://cons3rt/saltmaster/templates/bootstrap-saltminion-awsgovcloud.jinja
    - template: jinja
    - user: ec2-user
    - group: ec2-user
    - mode: '0775'
    - context:
      - minionpem: {{saltminionpem}}
      - minionpub: {{saltminionpub}}
      - minionid: {{value['fqdn']}}

aws-run-instance-{{value['fqdn']}}:
  cmd:
    - wait
    - name: aws ec2 run-instances --image-id {{value['image_id']}} --count 1 --instance-type {{value['instance_type']}} --key-name {{keyname}} --security-group-ids {{secgroup}} --subnet-id {{subnet}} --private-ip-address {{value['private_ip']}} >> /home/ec2-user/launched-aws-instances/{{value['fqdn']}}
    - watch:
      - file: aws-instance-{{value['fqdn']}}
{% endif %}{% endif %}{% endif %}{% endfor %}
{% endif %}



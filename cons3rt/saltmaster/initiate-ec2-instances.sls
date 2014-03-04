{% set infratype=pillar['cons3rt-infrastructure']['infrastructure_type'] %}
{% if infratype|lower=='aws' %}
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% set keyname=pillar['aws-credentials']['key_name'] %}
{% set launched=[] %}
{% set secgroup=pillar['aws-credentials']['security_group_id'] %}
{% set subnet=pillar['aws-credentials']['subnet_id'] %}
{% set saltminionpub=() %}
{% set saltminionpem=() %}
{% set saltminion=() %}
{% for host, value in hosts.iteritems() %}
{% if value['fqdn'] is defined and value['fqdn']|lower!='none' %}{% if launched is defined %}{% if value['fqdn'] not in launched %}
{% do launched.append(value['fqdn']) %}
/root/launched-aws-instances/{{value['fqdn']}}:
  file:
    - managed
    - makedirs: true
    - user: root
    - group: root
    - mode: '0644'

create-salt-minion-keys-{{value['fqdn']}}:
  cmd:
    - run
    - name: salt-key --gen-keys={{value['fqdn']}}
    - cwd: /root/launched-aws-instances
    - require:
      - file: /root/launched-aws-instances/{{value['fqdn']}}

move-public-key-{{value['fqdn']}}:
  cmd:
    - wait
    - name: cp /root/launched-aws-instances/{{value['fqdn']}}.pub /etc/salt/pki/master/minions/{{value['fqdn']}}
    - watch:
      - cmd: create-salt-minion-keys-{{value['fqdn']}}

/root/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh:
  file:
    - managed
    - source: salt://cons3rt/saltmaster/templates/bootstrap-saltminion-awsgovcloud.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - context:
      minionid: {{value['fqdn']}}

aws-run-instance-{{value['fqdn']}}:
  cmd:
    - wait
    - name: "aws ec2 run-instances --image-id {{value['image_id']}} --count 1 --instance-type {{value['instance_type']}} --key-name {{keyname}} --user-data file://root/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh --security-group-ids {{secgroup}} --subnet-id {{subnet}} --private-ip-address {{value['private_ip']}} >> /root/launched-aws-instances/{{value['fqdn']}}"
    - watch:
      - cmd: /root/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh
{% endif %}{% endif %}{% endif %}{% endfor %}
{% endif %}



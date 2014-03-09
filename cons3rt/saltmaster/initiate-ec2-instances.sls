{#-

Setup all needed variables for the transaction

-#}
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% set keyname=pillar['aws-credentials']['key_name'] %}
{% set launched=[] %}
{% set secgroup=pillar['aws-credentials']['security_group_id'] %}
{% set subnet=pillar['aws-credentials']['subnet_id'] %}
{% set saltminionpub=() %}
{% set saltminionpem=() %}
{% set saltminion=() %}
/root/launched-aws-instances:
  file:
    - directory
    - makedirs: true
    - user: root
    - group: root
{#-

Loop through the list of defined hosts from pillar

-#}
{% for host, value in hosts.iteritems() %}
{% if value['fqdn'] is defined and value['fqdn']|lower!='none' %}{% if launched is defined %}
{#-

Validate we are trying to attempt to build the same instance twice

-#}
{% if value['fqdn'] not in launched %}
{#-

Add the hostname to the 'launched' list

-#}
{% do launched.append(value['fqdn']) %}
{#-

If the fqdn named file already exists, do not attempt to repeat the process

-#}
{% if salt['file.file_exists']('/root/launched-aws-instances/'~value['fqdn'])==false %}
create-salt-minion-keys-{{value['fqdn']}}:
  cmd:
    - run
    - name: salt-key --gen-keys={{value['fqdn']}}
    - cwd: /root/launched-aws-instances
    - require:
      - file: /root/launched-aws-instances

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
    - mode: '0775'
    - context:
      minionid: {{value['fqdn']}}

aws-run-instance-{{value['fqdn']}}:
  cmd:
    - wait
    - name: aws ec2 run-instances --image-id {{value['image_id']}} --count 1 --instance-type {{value['instance_type']}} --key-name {{keyname}} --user-data file:///root/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh --security-group-ids {{secgroup}} --subnet-id {{subnet}} --private-ip-address {{value['private_ip']}} > /root/launched-aws-instances/{{value['fqdn']}}
    - watch:
      - file: /root/launched-aws-instances/bootstrap-{{value['fqdn']}}.sh

attach-public-ip-{{value['fqdn']}}:
  cmd:
    - wait
    - name: INSTANCE=`grep 'InstanceId' /root/launched-aws-instances/{{value['fqdn']}} | awk -F\" '{print $4}'`; while [ `aws ec2 describe-instance-status --instance-id $INSTANCE --include-all-instances --out text | grep 'INSTANCESTATE'| awk '{print $2}'` -ne '16' ]; do sleep 1; done; aws ec2 associate-address --instance-id $INSTANCE --private-ip-address {{value['private_ip']}} --public-ip {{value['ip']}}
    - watch:
      - cmd: aws-run-instance-{{value['fqdn']}}

tag-instance-{{value['fqdn']}}:
  cmd:
    - wait
    - name: INSTANCE=`grep 'InstanceId' /root/launched-aws-instances/{{value['fqdn']}} | awk -F\" '{print $4}'`; aws ec2 create-tags --resources $INSTANCE --tags Key=Name,Value={{value['fqdn']}}
    - watch:
      - cmd: attach-public-ip-{{value['fqdn']}}

{% endif %}{% endif %}{% endif %}{% endif %}{% endfor %}


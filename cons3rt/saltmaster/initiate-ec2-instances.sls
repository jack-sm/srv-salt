{% set infratype=pillar['cons3rt-infrastructure']['infrastructure_type'] %}
{% if infratype|lower=='aws' %}
{% set hosts=pillar['cons3rt-infrastructure']['hosts'] %}
{% set keyname=pillar['aws-credentials']['key_name'] %}
{% set secgroup=pillar['aws-credentials']['security_group_id'] %}
{% set subnet=pillar['aws-credentials']['subnet_id'] %}
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

aws-run-instance-{{value['fqdn']}}:
  cmd:
    - wait
    - name: aws ec2 run-instances --image-id {{value['image_id']}} --count 1 --instance-type {{value['instance_type']}} --key-name {{keyname}} --security-group-ids {{secgroup}} --subnet-id {{subnet}} --private-ip-address {{value['private_ip']}} >> /root/launched-aws-instances/{{value['fqdn']}}
    - watch:
      - file: aws-instance-{{value['fqdn']}}
{% endif %}{% endif %}{% endif %}{% endfor %}
{% endif %}



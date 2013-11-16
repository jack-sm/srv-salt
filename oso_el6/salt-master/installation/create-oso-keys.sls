{% set filespath=salt['pillar.get']('master:file_roots:base') %}
create-access-keys:
  cmd:
    - run
    - names: 
       - openssl genrsa -out {{filespath[0]}}/oso_el6/broker/keys/server_priv.pem 2048
       - openssl rsa -in {{filespath[0]}}/oso_el6/broker/keys/server_priv.pem -pubout > {{filespath[0]}}/oso_el6/broker/keys/server_pub.pem
       - ssh-keygen -t rsa -b 2048 -f {{filespath[0]}}/oso_el6/broker/keys/rsync_id_rsa -N ""

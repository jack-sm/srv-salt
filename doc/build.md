# Cons3rt Platform Installation

This document walks through the process of building a Salt master in AWS,
configuring it, and using it to build the virtual machines that will host
the Cons3rt application.

## The Salt Master
The Salt Master consists of two parts: 

- A vm in AWS
- a bootstrap script to configure it.

### Salt Master vm Details
In Govcloud, the Salt Master uses the following details:

```
  image: ami-97fb9fb4  #Amazon Linux, x86_64
  size: m1.medium
  security group: salt-master
  ip: 96.127.46.30
```

**NOTE**: The IP is very important. This is the IP that salt-cloud uses as the master for the Salt minions to connect to.

### Salt Master Bootstrap Script
The bootstrap script installs Salt and configures it to use the `jack-sm` project in Github for states and use S3 for the fileserver backend.

The script contains AWS credentials, so it cannot be included
with this document. It has been placed in the `configs` S3 bucket in
Govcloud. [Log into the Govcloud console](https://signin.amazonaws-us-gov.com) (project name `pci-sm-govcloud`),
navigate to the `configs` bucket in S3, and download the script titled `bootstrap-aws--saltmaster.sh`.

Pass this script as a user-data script when creating the VM or simply log into the Salt Master and run it as root. 

## Create the CONS3RT Infrastructure
Log into the salt-master and check to make sure that the salt-minion service is running. Issue the following command if this is a new salt-master installation:

```
salt-key -a saltmaster
```

Now that the salt-master is ready, issue the following command to build all of the cons3rt infrastructure vms:

```
salt-call state.sls cons3rt.saltmaster.initiate-ec2-instances
```

The above command will use the aws-cli along with information that has been populated within /srv/pillar/cons3rt_aws.sls to build the instances, and authorize
them with the salt-master. A folder will be created named `/root/launched-aws-instances` which contains the bootstrap scripts, salt-minion
keys and the output of running the aws cli. If you wish to rebuild the instances, remove the contents of this folder, use the aws cli or [web console](https://signin.amazonaws-us-gov.com)
 to destroy the instances, and re-run the above salt-call command. 

## Run the Highstate
The `highstate` is the collection of all Salt automation to configure the vms. As root, run the following command:

```
salt '*cons3rt*' state.highstate
```

After some time (usually under five minutes), the command will return with the output of the highstate and the VMs will have been successfully configured.

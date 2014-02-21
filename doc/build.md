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
navigate to the `configs` bucket in S3, and download the script titled `bootstrap-govcloud-salt-master.sh`.

Pass this script as a user-data script when creating the VM or simply log into the Salt Master and run it as root. 

## Salt-Cloud
The configuration of salt-cloud is handled by the bootstrap script. This explanation is here for the reader's edification.

Salt-cloud is a cloud controller that is installed with Salt. It allows creation of single, simple VMs or deployment of multiple VMs, each with specific Salt Minion configurations. This deployment uses a [cloud map](http://salt-cloud.readthedocs.org/en/latest/topics/map.html) file to deploy the vms, assign them a role (via [salt grains](http://docs.saltstack.com/topics/targeting/grains.html)), and prepare them to run a `highstate`, which configures the Cons3rt prereqs.

## Create the vms that Will Host Cons3rt
The salt-cloud configs include a map file that describes the vms that will host Cons3rt. We will use this map file and the `-P` parameter to launch the vms in parallel. As root, issue the following command and answer `yes` to the prompt:

```
salt-cloud -m /etc/salt/cons3rt.map -P
[INFO    ] salt-cloud starting
[INFO    ] Applying map from '/etc/salt/cons3rt.map'.
The following virtual machines are set to be created:
  www.aws.cons3rt.com
  cons3rt.aws.cons3rt.com
  sourcebuilder.aws.cons3rt.com
  toolbox.aws.cons3rt.com
  database.aws.cons3rt.com
  test-soapui.aws.cons3rt.com
  library.aws.cons3rt.com
```

**NOTE** You may see the following warning when issuing `salt` and `salt-cloud` commands. 

```
/usr/lib64/python2.6/site-packages/Crypto/Util/number.py:57: PowmInsecureWarning: Not using mpz_powm_sec...
```

These warnings are a known issue and will be corrected in future versions.

Once the process has completed, you can verify that the vms were created and have connected to the Salt Master with `salt-key`:

```
salt-key 
Accepted Keys:
cons3rt.aws.cons3rt.com
database.aws.cons3rt.com
library.aws.cons3rt.com
master
sourcebuilder.aws.cons3rt.com
test-soapui.aws.cons3rt.com
toolbox.aws.cons3rt.com
www.aws.cons3rt.com
Unaccepted Keys:
Rejected Keys:

```

**NOTE** The `salt-key` command lists the minions that have connected to the Master. In the case that a vm must be deleted, you must also delete the corresponding key. For example:

```
salt-key -d www.aws.cons3rt.com
```

## Run the Highstate
The `highstate` is the collection of all Salt automation to configure the vms. As root, run the following command:

```
salt '*cons3rt*' state.highstate
```

After some time (usually under five minutes), the command will return with the output of the highstate and the VMs will have been successfully configured.

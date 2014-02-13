# Cons3rt Platform Installation

This document walks through the process of building a Salt master in AWS,
configuring it, and using it to build the virtual machines that will host
the Cons3rt application. 

## Build the Salt Master
The Salt Master consists of two parts: A vm in AWS, and a bootstrap script
to configure it.

### Salt Master vm Details
In Govcloud, the Salt Master uses the following image ID and size:

```
  image: ami-97fb9fb4  #Amazon Linux, x86_64
  size: m1.medium
```

### Salt Master Bootstrap Script
The bootstrap script installs Salt and configures it to use the `jack-sm` project in Github for states and use S3 for the fileserver backend.

The script contains AWS credentials, so it cannot be included
with this document. It has been placed in the `configs` S3 bucket in
Govcloud. [Log into the Govcloud console](https://signin.amazonaws-us-gov.com) (project name `pci-sm-govcloud`),
navigate to the `configs` bucket in S3, and download the script titled `bootstrap-govcloud-salt-master.sh`.

Pass this script as a user-data script when creating the VM or simply log into the Salt Master and run it as root. 

## Configure Salt-Cloud
Salt-cloud is a cloud controller that is installed with Salt. It allows creation of single, simple VMs or deployment of multiple VMs, each with specific Salt Minion configurations. This deployment uses a [cloud map](http://salt-cloud.readthedocs.org/en/latest/topics/map.html) file to deploy the vms, assign them a role (via [salt grains](http://docs.saltstack.com/topics/targeting/grains.html)), and prepare them to run a `highstate`, which configures the Cons3rt prereqs.


Since `salt-cloud` is installed with Salt, the only task is to configure it.

The configurations are also stored in the `configs` bucket in S3. Navigate to the bucket and download the tarball titled `salt-cloud-config.tar`. Place the file on the Salt Master and unpack it, as follows.

```bash
mv salt-cloud-config.tar /etc/salt/.
tar -xvf salt-cloud-config.tar
rm salt-cloud-config.tar
```

This unpacks the config files required for `salt-cloud`.
# UpCloud VM

UpCloud referral to get $25 credits: [https://upcloud.com/signup/?promo=Y2RZ4S](https://upcloud.com/signup/?promo=Y2RZ4S)

Source code @ [https://github.com/tappoz/scripting-utilities/upcloud-vm](https://github.com/tappoz/scripting-utilities/upcloud-vm)

# Checklist

## UpCloud subaccount

Generate an UpCloud subaccount on their dashboard
(left panel > People > +Add), then:

```bash
export UPCLOUD_USERNAME=***
export UPCLOUD_PASSWORD=***
```

This is a handy command to generate long passwords: `makepasswd  --chars=100`.

## Cleanup and SSH keys for the `root` user

Clean all the SSH keys, Terraform initialization files etc. with:

```bash
make clean
```

Generate the SSH keys for the root user with:

```bash
make ssh-generate-key-pair-root
```

## Infrastructure deployment with Terraform and SDK checks

```sh
# install the `terraform` command
make tf-install
# initialize the UpCloud project with the VM definition
make tf-init
# check the plan from Terraform P.O.V.
make tf-plan
# enact the Terraform plan
make tf-apply
```

This will deploy a new Virtual Machine on UpCloud.

Check the UpCloud infrastructure with the Python SDK:

```bash
# install the `pip` dependencies
make pip-install
# run the Python script to retrieve the
# UpCloud infrastructure details
make upcloud-inspect
```

## Make a note of the IP address of the running VM

Go to the UpCloud dashboard > click on the server name > scroll down to "How to connect". Make a note of the IP address of the running Virtual Machine.

Export the IP address as an environment variable so the `Makefile` targets
can find it and use it to connect to the VM via SSH.

```bash
export UPCLOUD_IP=ddd.ddd.ddd.ddd
```

## Connect via SSH into the VM on UpCloud

```bash
# make sure the SSH keys have the right permissions (600)
make ssh-fix-permissions
# connect to the VM via SSH
make ssh-as-root
```

## Add an admin user to the VM via Ansible

```bash
# generate an SSH key pair for the user agadmin
make ssh-generate-key-pair-agadmin
# make sure Ansible is installed (via Python)
make pip-install
# run the Ansible playbook to configure the new VM user
make ansible-provision
# make sure the SSH keys have the right permissions (600)
make ssh-fix-permissions
# connect to the VM via SSH with the fresh new admin user
make ssh-as-agadmin
```

## Terraform destroy

Now that the whole configuration journey proved to work,
we can destroy the infrastructure on UpCloud to cleanup the environment.

```bash
# Terraform destroy
make tf-destroy
# file system cleanup
# (remove passwords, sensitive information, and state files)
make clean
```







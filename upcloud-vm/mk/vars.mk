# variables
BIN_DIR=$(PWD)/bin
CONF_DIR=$(PWD)/conf

# Terraform
TF_VERSION=1.0.9
TF_ZIPFILE=terraform_$(TF_VERSION)_linux_amd64.zip

# colors
RED=\033[1;31m
GRN=\033[1;32m
YEL=\033[1;33m
MAG=\033[1;35m
CYN=\033[1;36m
NC=\033[0m

# logging stuff
TIMESTAMP := $$(date "+%Y-%m-%d %H:%M:%S")
LOG_PREFIX=$(CYN)$(TIMESTAMP)$(NC) $(RED)UPCLOUD-VM$(NC)

# UpCloud > click on the server name > scroll down to "How to connect"
# ```bash
# export UPCLOUD_IP=ddd.ddd.ddd.ddd
# ```
VM_HOST=$(UPCLOUD_IP)

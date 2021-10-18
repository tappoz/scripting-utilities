include mk/vars.mk
include mk/provisioning.mk
include mk/ssh.mk
include mk/terraform.mk

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# UpCloud referral to get $25 credits: https://upcloud.com/signup/?promo=Y2RZ4S
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
# Git repo with code: https://github.com/tappoz/scripting-utilities/upcloud-vm

clean:
# clean SSH files and add back their placeholders
	@echo "$(LOG_PREFIX) $(YEL)Cleaning SSH key pairs...$(NC)"
	-rm $(CONF_DIR)/agadmin_ag_tppz_vm     && touch $(CONF_DIR)/agadmin_ag_tppz_vm
	-rm $(CONF_DIR)/agadmin_ag_tppz_vm.pub && touch $(CONF_DIR)/agadmin_ag_tppz_vm.pub
	-rm $(CONF_DIR)/root_ag_tppz_vm        && touch $(CONF_DIR)/root_ag_tppz_vm
	-rm $(CONF_DIR)/root_ag_tppz_vm.pub    && touch $(CONF_DIR)/root_ag_tppz_vm.pub
# clean Terraform command and state files
	@echo "$(LOG_PREFIX) $(YEL)Cleaning Terraform state...$(NC)"
	-rm $(BIN_DIR)/terraform
	-rm -r $(PWD)/tf/.terraform
	-rm $(PWD)/tf/.terraform.lock.hcl
	-rm $(PWD)/tf/terraform.tfstate
	-rm $(PWD)/tf/terraform.tfstate.backup
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"
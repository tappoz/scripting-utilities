tf-install:
	@echo "$(LOG_PREFIX) $(YEL)Installing Terraform Version $(TF_VERSION)$(NC)"
	mkdir -p $(BIN_DIR)
	-rm $(BIN_DIR)/terraform
	wget https://releases.hashicorp.com/terraform/$(TF_VERSION)/$(TF_ZIPFILE)
	unzip $(TF_ZIPFILE) -d $(BIN_DIR)
	rm $(TF_ZIPFILE)
	@echo "$(LOG_PREFIX) $(YEL)Checking the installation of Terraform $(TF_VERSION)$(NC)"
	ls -lah $(BIN_DIR)
	$(BIN_DIR)/terraform -v
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

tf-fmt:
	@echo "$(LOG_PREFIX) $(YEL)Formatting Terraform code...$(NC)"
	ls -lah $(PWD)/tf/
	$(BIN_DIR)/terraform fmt -recursive $(PWD)/tf/
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

tf-init:
	@echo "$(LOG_PREFIX) $(YEL)Initializing Terraform project...$(NC)"
	cd $(PWD)/tf && $(BIN_DIR)/terraform init
	cd $(PWD)/tf && tree -a
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

# Make sure your UpCloud subaccount is allowing
# commands coming from your public IP address
tf-plan:
	@echo "$(LOG_PREFIX) $(YEL)Terraform plan...$(NC)"
	cd $(PWD)/tf && $(BIN_DIR)/terraform plan
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

# upcloud_server.server-ag-tppz-vm: Creating...
# upcloud_server.server-ag-tppz-vm: Still creating... [10s elapsed]
# upcloud_server.server-ag-tppz-vm: Still creating... [20s elapsed]
# upcloud_server.server-ag-tppz-vm: Creation complete after 23s [id=<UUID>]
tf-apply:
	@echo "$(LOG_PREFIX) $(YEL)Terraform apply...$(NC)"
	cd $(PWD)/tf && $(BIN_DIR)/terraform apply
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

tf-destroy:
	@echo "$(LOG_PREFIX) $(YEL)Terraform destroy...$(NC)"
	cd $(PWD)/tf && $(BIN_DIR)/terraform destroy
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

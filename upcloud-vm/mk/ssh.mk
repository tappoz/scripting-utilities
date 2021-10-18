ssh-generate-key-pair-root:
	@echo "$(LOG_PREFIX) $(YEL)Generating SSH keys for the root user...$(NC)"
	ls -lah $(CONF_DIR)
	-rm $(CONF_DIR)/root_ag_tppz_vm*
	ssh-keygen \
		-q \
		-t ecdsa \
		-f $(CONF_DIR)/root_ag_tppz_vm \
		-P "" -N "" -C ""
	ls -lah $(CONF_DIR)
	@echo "$(LOG_PREFIX) $(YEL)This is the root user public key...$(NC)"
	cat $(CONF_DIR)/root_ag_tppz_vm.pub
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

ssh-generate-key-pair-agadmin:
	@echo "$(LOG_PREFIX) $(YEL)Generating SSH keys for the agadmin user...$(NC)"
	ls -lah $(CONF_DIR)
	-rm $(CONF_DIR)/agadmin_ag_tppz_vm*
	ssh-keygen \
		-q \
		-t ecdsa \
		-f $(CONF_DIR)/agadmin_ag_tppz_vm \
		-P "" -N "" -C ""
	ls -lah $(CONF_DIR)
	@echo "$(LOG_PREFIX) $(YEL)This is the agadmin user public key...$(NC)"
	cat $(CONF_DIR)/agadmin_ag_tppz_vm.pub
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

ssh-fix-permissions:
	@echo "$(LOG_PREFIX) $(YEL)Make sure the SSH keys have the expected file permissions...$(NC)"
	chmod 600 $(CONF_DIR)/*ag_tppz_vm*
	@echo "$(LOG_PREFIX) $(YEL)Check the directory content for file permissions...$(NC)"
	ls -lah $(CONF_DIR)/*ag_tppz_vm*

ssh-as-root:
	@echo "$(LOG_PREFIX) $(YEL)SSH into the VM as root...$(NC)"
	ssh -v root@$(VM_HOST) \
		-i $(CONF_DIR)/root_ag_tppz_vm \
		-o ConnectTimeout=10 \
		-o BatchMode=yes \
		-o StrictHostKeyChecking=no

ssh-as-agadmin:
	@echo "$(LOG_PREFIX) $(YEL)SSH into the VM as agadmin...$(NC)"
	ssh -v agadmin@$(VM_HOST) \
		-i $(CONF_DIR)/agadmin_ag_tppz_vm \
		-o ConnectTimeout=10 \
		-o BatchMode=yes \
		-o StrictHostKeyChecking=no

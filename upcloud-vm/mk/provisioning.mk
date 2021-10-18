pip-install:
	@echo "$(LOG_PREFIX) $(YEL)Install the Python dependency on your local machine...$(NC)"
	cat $(CONF_DIR)/requirements.txt
	@echo "$(LOG_PREFIX) $(YEL)Run pip$(NC)"
	pip install -r $(CONF_DIR)/requirements.txt
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

upcloud-inspect:
	@echo "$(LOG_PREFIX) $(YEL)Inspecting the UpCloud infrastructure...$(NC)"
	./bin/show_upcloud_infrastructure.py
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

ansible-provision:
	@echo "$(LOG_PREFIX) $(YEL)Provisioning via Ansible...$(NC)"
	ansible-playbook \
		--private-key $(CONF_DIR)/root_ag_tppz_vm \
		--user root \
		--inventory $(VM_HOST), \
		-vv \
		$(CONF_DIR)/ansible/users.yml
	@echo "$(LOG_PREFIX) $(GRN)DONE$(NC)"

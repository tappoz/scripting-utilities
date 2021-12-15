# Assuming these tools are already installed:
# - Kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# - Minikube: https://minikube.sigs.k8s.io/docs/start/

install-pip:
	$(call log_this,"Install the Pip (Python) requirements")
	pip install -r $(PWD)/requirements.txt
	pip install -r $(PWD)/requirements_devops.txt
	$(call log_this,"DONE Install the Pip (Python) requirements")

install-kubeval:
	cd $(HOME)/tmp && \
		wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz && \
		tar xf kubeval-linux-amd64.tar.gz && \
		sudo mv kubeval /usr/local/bin
	kubeval --version

install-polaris:
	cd $(HOME)/tmp && \
		wget https://github.com/FairwindsOps/polaris/releases/download/4.2.0/polaris_linux_amd64.tar.gz && \
		tar xvzf polaris_linux_amd64.tar.gz && \
		sudo mv polaris /usr/local/bin/
		polaris version

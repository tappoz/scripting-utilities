#
# The source code is at:
# https://github.com/tappoz/scripting-utilities/tree/master/kubernetes/cronjob
#

# --------------------------------------------------------- #
# Install Kubectl                                           #
# Install and configure Minikube (local Kubernetes cluster) #
# Install linters                                           #
# Install Lens - the Kunernetes IDE                         #
# --------------------------------------------------------- #

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
kubectl-install:
	sudo apt-get update && \
		sudo apt-get install -y apt-transport-https ca-certificates curl
	sudo curl -fsSLo \
		/usr/share/keyrings/kubernetes-archive-keyring.gpg \
		https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
		sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl
	kubectl version --client


# https://minikube.sigs.k8s.io/docs/start/
minikube-upsert:
	-minikube version
	-mkdir -p $(HOME)/tmp
	cd $(HOME)/tmp && \
		curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb && \
		sudo dpkg -i minikube_latest_amd64.deb
	minikube version

# the first time you setup a Minikube cluster 
# this may take a few minutes to bootstrap
minikube-start:
	kubectl config get-contexts
	minikube start
	kubectl config get-contexts
	cat $(HOME)/.kube/config

linters-install:
# pip (python packages)
	pip install \
		black==21.8b0 \
		pytype==2021.10.25 \
		flake8==4.0.1 \
		pylint==2.10.2 \
		bandit==1.7.0 \
		yamllint==1.26.3
# kubeval (YAML for Kubernetes)
	cd $(HOME)/tmp && \
		wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz && \
		tar xf kubeval-linux-amd64.tar.gz && \
		sudo cp kubeval /usr/local/bin
	kubeval --version

# https://k8slens.dev/
lens-install:
	cd $(HOME)/tmp && \
		wget https://api.k8slens.dev/binaries/Lens-5.2.5-latest.20211001.2.amd64.deb && \
		sudo dpkg -i Lens-5.2.5-latest.20211001.2.amd64.deb

# ----------------------------------- #
# Build and run a Python Docker image #
# ----------------------------------- #

lint-py-script:
# format the source code with sane defaults
	black cj_sample.py
# check for types and unattended side effects
	pytype cj_sample.py
# check for cyclomatic complexity and basic linting rules e.g. unused imports
	flake8 --max-complexity=4 cj_sample.py
# heavy linting
	pylint --disable=C0114,C0116 cj_sample.py
# scan for vulnerabilities
	bandit \
		--recursive \
		--number 3 \
		-lll \
		-iii \
		cj_sample.py

docker-build:
	docker build . \
		--file cj-sample.Dockerfile \
		--tag cj-sample-i
	docker images | grep -E 'python|cj-sample'

# alternative command:
# minikube image load cj-sample-i:latest
# minikube image ls
docker-build-minikube:
	eval $(shell minikube -p minikube docker-env) && \
	docker build . \
		--file cj-sample.Dockerfile \
		--tag cj-sample-i
	docker images | grep -E 'python|cj-sample'

docker-run:
	docker run \
		-it --rm \
		cj-sample:latest

# check the available schemas:
# https://github.com/instrumenta/kubernetes-json-schema/tree/master/master-standalone-strict
kube-lint:
	yamllint \
		--config-data "{extends: relaxed, rules: {indentation: {spaces: 2}, document-start: enable, line-length: {max: 120, allow-non-breakable-words: true, allow-non-breakable-inline-mappings: true}}}" \
		--strict \
		deployment/*
	kubeval \
		--strict \
		deployment/*

# -------------------------------------------------------------------- #
# Deploy a Kubernetes CronJob based on this Docker image               #
# https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/ #
# -------------------------------------------------------------------- #

# use "--dry-run=client" to validate the YAML directives
# (create/update/delete/apply and so on...)
kube-deploy:
	kubectl config use-context minikube
	kubectl apply \
		--filename deployment/k-cj-namespace.yaml
	kubectl get namespaces --show-labels
	kubectl apply \
		--filename deployment/k-cj-app.yaml \
		--namespace cj-explorations
	kubectl get cronjobs --namespace cj-explorations
	kubectl get pods --namespace cj-explorations

kube-clean-delete:
	kubectl config use-context minikube
	kubectl get cronjobs --namespace cj-explorations
	-kubectl delete \
		--filename deployment/k-cj-app.yaml \
		--namespace cj-explorations
	-kubectl get pods --namespace cj-explorations
	kubectl get pods --namespace cj-explorations | \
		grep -v NAME | \
		awk '{print $$1}' | \
		xargs kubectl delete pod --namespace cj-explorations


# ------------------------------------------------ #
# Monitor and troubleshoot this Kubernetes CronJob #
# ------------------------------------------------ #

kube-status:
	kubectl config get-contexts
	-kubectl get pods --namespace cj-explorations
	-kubectl get cronjobs --namespace cj-explorations

kube-logs:
	for kjob in $(shell kubectl get jobs --namespace cj-explorations | grep -v NAME | awk '{print $$1}'); do \
		echo "\nlogs for $$kjob:\n"; \
		kubectl logs job.batch/$$kjob --namespace cj-explorations; \
	done;

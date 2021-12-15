# https://minikube.sigs.k8s.io/docs/start/
minikube-nuke-and-pave:
	$(call log_this,"Deleting the Minikube cluster")
	-minikube delete
	$(call log_this,"Staring a new the Minikube cluster")
	minikube start 
	$(call log_this,"Showing the Minikube profiles")
	minikube profile list

minikube-sync:
	$(call log_this,"Uploading the Docker images to the Minikube cluster")
	minikube image load postgres:12.6-alpine
	minikube image load flaskapp-i:latest
	$(call log_this,"Inspecting the Docker images stored into the Minikube cluster")
	minikube image ls | grep docker.io/library

k8s-set-cluster:
	$(call log_this,"Checking the Kubernetes cluster context")
	kubectl config get-contexts
	$(call log_this,"Making sure the Kubernetes context is 'Minikube'")
	kubectl config use-context minikube
	$(call log_this,"Showing the Minikube profiles")
	minikube profile list
	$(call log_this,"Checking again the Kubernetes cluster context")
	kubectl config get-contexts
	$(call log_this,"DONE checking the Kubernetes cluster context")

k8s-apply-namespace:
	$(call log_this,"Creating the Kubernetes Namespace")
	kubectl \
		apply \
			--filename $(PWD)/k8s/namespace.yaml
	$(call log_this,"DONE Creating the Kubernetes Namespace")

k8s-apply-db:
	$(call log_this,"Creating the Kubernetes DB Deployment Persitent Volume Secret etc")
	kubectl \
		apply \
			--filename $(PWD)/k8s/db/
	$(call log_this,"DONE Creating the Kubernetes DB Deployment Persitent Volume Secret etc")

k8s-apply-flaskapp:
	$(call log_this,"Creating the Kubernetes Flask App REST API")
	kubectl \
		apply \
			--filename $(PWD)/k8s/rest-api/
	$(call log_this,"DONE Creating the Kubernetes Flask App REST API")

k8s-delete:
	$(call log_this,"Deleting *ALL* the Kubernetes Resources")
	kubectl delete \
		deployment,service,secret,persistentvolumeclaim,persistentvolume \
		--all \
		--namespace $(K8S_NAMESPACE)
	-kubectl delete namespaces $(K8S_NAMESPACE)
	$(call log_this,"DONE Deleting *ALL* the Kubernetes Resources")

k8s-status:
	$(call log_this,"Checking the Kubernetes Cluster Status")
	kubectl \
		get \
			--filename $(PWD)/k8s/ \
			--filename $(PWD)/k8s/db/ \
			--filename $(PWD)/k8s/rest-api/
	$(call log_this,"DONE Checking the Kubernetes Cluster Status")

# to check the persistent volume storage:
# `minikube ssh`
# then: `sudo ls -lah /mnt/pg-data/`
k8s-configure-db:
	minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE)
	$(eval DB_HOST=$(shell minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.IP}}))
	$(eval DB_PORT=$(shell minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.Port}}))
	DB_HOST=$(DB_HOST) DB_PORT=$(DB_PORT) $(MAKE) config-db

k8s-logs:
	$(call log_this,"Showing the logs for the Kubernetes deployments")
	for K_DEPLOYMENT in $(shell kubectl get pods --namespace $(K8S_NAMESPACE) | grep -v NAME | awk '{print $$1}'); do \
		echo "$(YEL)\nBEGIN logs for $(RED)$$K_DEPLOYMENT\n$(NC)"; \
		kubectl logs $$K_DEPLOYMENT --namespace $(K8S_NAMESPACE); \
		echo "$(YEL)\nEND logs for $(RED)$$K_DEPLOYMENT\n$(NC)"; \
	done;
	$(call log_this,"DONE Showing the logs for the Kubernetes deployments")


# Install `krew`: https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# Then: `kubectl krew install graph` (https://github.com/steveteuber/kubectl-graph)
# Then: `sudo apt install graphviz`
k8s-plot:
	kubectl graph \
		secrets,services,deployments,persistentvolume,persistentvolumeclaim \
		--namespace $(K8S_NAMESPACE) | \
		dot -T png -o k8s.png

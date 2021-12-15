# when not using `util.configure_logger()`: --log-cli-level DEBUG
test-python:
	$(call log_this,"Running the Python Unit Test with Pytest")
	PYTHONPATH=. pytest \
		-s \
		$(PWD)/tests/
	$(call log_this,"DONE Running the Python Unit Test with Pytest")

integration-test-http:
	$(call log_this,"Running the HTTP integration tests")
	PYTHONPATH=. pytest \
		-s \
		$(PWD)/http-tests/http_integration_tests.py
	$(call log_this,"DONE Running the HTTP integration tests")

# This is to check (see) the effect of the validation
# rules when parsing:
# - HTTP path parameters
# - HTTP query parameters
integration-test-http-curl:
	$(call log_this,"Running some *genuine* GET HTTP calls with CURL")
# genuine
	curl -X GET -v $(API_HOST_PORT)/uuids?amount=3
	@echo ""
	curl -X GET -v $(API_HOST_PORT)/uuid/1
	@echo ""
	$(call log_this,"DONE Running some *genuine* GET HTTP calls with CURL")
# malicious
	$(call log_this,"Running some *malicious* GET HTTP calls with CURL")
	curl -X GET -v $(API_HOST_PORT)/uuids?amount=3x
	@echo ""
	curl -X GET -v $(API_HOST_PORT)/uuid/abc1
	@echo ""
	$(call log_this,"DONE Running some *malicious* GET HTTP calls with CURL")

# This is to quickly troubleshoot
# the HTTP POST API endpoint
integration-test-post-curl:
	$(call log_this,"Running a POST HTTP call with CURL")
	curl -X POST \
		-v \
		-H "Content-Type: application/json" \
		-d '["fd9e7928-e876-40df-aaca-fb084f419be1"]' \
		$(API_HOST_PORT)/uuids
	$(call log_this,"DONE Running a POST HTTP call with CURL")

k8s-integration-test-http:
	$(call log_this,"Running the HTTP integration tests against the Kubernetes cluster")
	minikube service --url $(K8S_REST_API_SERVICE) --namespace $(K8S_NAMESPACE)
	$(eval K8S_HOST_PORT=$(shell minikube service --url $(K8S_REST_API_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.IP}}:{{.Port}}))
	K8S_HOST_PORT=$(K8S_HOST_PORT) $(MAKE) integration-test-http
	$(call log_this,"DONE Running the HTTP integration tests against the Kubernetes cluster")

test-db-connectivity:
	$(call log_this,"Testing the Postgres DB connectivity")
	PGPASSWORD=$(DB_PSWD) psql \
		--username=$(DB_USER) \
		--host=$(DB_HOST) \
		--port=$(DB_PORT) \
		--command='SELECT NOW()'
	$(call log_this,"DONE Testing the Postgres DB connectivity")

k8s-test-db-connectivity:
	$(call log_this,"Testing the Kubernetes DB service connectivity")
	minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE)
	$(eval MK_DB_HOST=$(shell minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.IP}}))
	$(eval MK_DB_PORT=$(shell minikube service --url $(K8S_DB_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.Port}}))
	DB_HOST=$(MK_DB_HOST) DB_PORT=$(MK_DB_PORT) $(MAKE) test-db-connectivity
	$(call log_this,"DONE Testing the Kubernetes DB service connectivity")

test-api-connectivity:
	$(call log_this,"Testing the REST API service connectivity")
	curl -X GET -v http://$(API_HOST_PORT)/uuids?amount=2
	$(call log_this,"DONE Testing the REST API service connectivity")

k8s-test-api-connectivity:
	$(call log_this,"Testing the Kubernetes REST API service connectivity")
	$(eval MK_REST_HOST_PORT=$(shell minikube service --url $(K8S_REST_API_SERVICE) --namespace $(K8S_NAMESPACE) --format={{.IP}}:{{.Port}}))
	API_HOST_PORT=$(MK_REST_HOST_PORT) $(MAKE) test-api-connectivity
	$(call log_this,"DONE Testing the Kubernetes REST API service connectivity")

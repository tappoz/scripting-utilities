include mk/install.mk
include mk/var.mk
include mk/config.mk
include mk/docker.mk
include mk/k8s.mk
include mk/lint.mk
include mk/test.mk

run:
	$(call log_this,"Run the Python REST API")
	PYTHONPATH=. python $(PWD)/src/main.py

clean:
	rm *.log
	find . -type d -name  "__pycache__" -exec rm -r {} +

docker-ceremony:
	$(MAKE) docker-stop
	$(MAKE) docker-network
	$(MAKE) docker-db
	sleep 5
	$(MAKE) test-db-connectivity
	$(MAKE) config-db
	$(MAKE) test-python
	$(MAKE) docker-build-http-api
	sleep 5
	$(MAKE) docker-run-http-api
	sleep 5
	$(MAKE) test-api-connectivity
	$(MAKE) docker-status
	$(MAKE) integration-test-http
	sleep 2
	$(MAKE) docker-logs
	$(MAKE) docker-stop

k8s-ceremony:
	$(MAKE) k8s-delete
	$(MAKE) k8s-set-cluster
	$(MAKE) k8s-apply-namespace
	$(MAKE) k8s-apply-db
	sleep 5
	$(MAKE) k8s-test-db-connectivity
	$(MAKE) k8s-configure-db
	$(MAKE) k8s-apply-flaskapp
	sleep 5
	$(MAKE) k8s-test-api-connectivity
	$(MAKE) k8s-status
	$(MAKE) k8s-integration-test-http
	sleep 2
	$(MAKE) k8s-delete

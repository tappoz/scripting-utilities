PY_SRC_PATH=$(PWD)/src
PY_TESTS_PATH=$(PWD)/tests
# these happen to be written in Python, 
# but this is not necessarily always true
INTEGRATION_TESTS_PATH=$(PWD)/http-tests

# - https://github.com/psf/black
# - https://flake8.pycqa.org/en/latest/user/error-codes.html
# - https://pylint.pycqa.org/en/latest/technical_reference/features.html
# - https://github.com/google/pytype
# - https://github.com/PyCQA/bandit
# - https://github.com/PyCQA/isort
# - https://github.com/sqlfluff/sqlfluff
# - https://yamllint.readthedocs.io/en/stable/
# - https://www.kubeval.com/
# - https://polaris.docs.fairwinds.com/infrastructure-as-code/#running-in-a-ci-pipeline
lint:
# python
	$(call log_this,"Applying Isort the Python imports")
	isort \
		--atomic \
		$(PY_SRC_PATH) \
		$(PY_TESTS_PATH) \
		$(INTEGRATION_TESTS_PATH)
	$(call log_this,"Applying Black to the Python source code")
	black \
		$(PY_SRC_PATH) \
		$(PY_TESTS_PATH) \
		$(INTEGRATION_TESTS_PATH)
	$(call log_this,"Applying Flake8 to the Python source code")
	flake8 \
		--ignore=C901,E501,W503,W504, \
		--max-complexity=4 \
		--jobs=8 \
		$(PY_SRC_PATH) \
		$(PY_TESTS_PATH) \
		$(INTEGRATION_TESTS_PATH)
	$(call log_this,"Applying Pylint to the Python source code")
	pylint \
		--disable=C0114,C0115,C0116,W0511,W1203 \
		--jobs=6 \
		$(PY_SRC_PATH) \
		$(PY_TESTS_PATH) \
		$(INTEGRATION_TESTS_PATH)
	$(call log_this,"Applying Pytype to the Python source code")
	PYTHONPATH=. pytype \
		--keep-going \
		--jobs=8 \
		$(PY_SRC_PATH)
	$(call log_this,"Applying Bandit to the Python source code")
	bandit \
		--recursive \
		--number=3 \
		-lll \
		-iii \
		$(PY_SRC_PATH) \
		$(PY_TESTS_PATH) \
		$(INTEGRATION_TESTS_PATH)
# postgres sql
	$(MAKE) lint-fix-sql
# kubernetes
	$(MAKE) lint-k8s

lint-fix-sql:
	$(call log_this,"Applying SQLFluff to the Python source code")
	sqlfluff fix \
		--verbose \
		--force \
		--dialect=postgres \
		$(PWD)/sql/*

lint-k8s:
	$(call log_this,"Applying Yamllint to the Kubernetes YAML config files")
	yamllint \
		--config-data "{extends: relaxed, rules: {indentation: {spaces: 2}, document-start: enable, line-length: {max: 120, allow-non-breakable-words: true, allow-non-breakable-inline-mappings: true}}}" \
		--strict \
		k8s/*
# check the available schemas:
# https://github.com/instrumenta/kubernetes-json-schema/tree/master/master-standalone-strict
	$(call log_this,"Applying Kubeval to the Kubernetes YAML config files")
	kubeval \
		--strict \
		$(PWD)/k8s/*.yaml
	kubeval \
		--strict \
		$(PWD)/k8s/db/*
	kubeval \
		--strict \
		$(PWD)/k8s/rest-api/*
# https://github.com/fairwindsops/polaris/releases
# https://polaris.docs.fairwinds.com/infrastructure-as-code/
	$(call log_this,"Applying Polaris to the Kubernetes YAML config files")
	polaris audit \
		--audit-path $(PWD)/k8s \
		--set-exit-code-on-danger \
		--only-show-failed-tests true \
		--set-exit-code-below-score 50 \
		--config $(PWD)/polaris-k8s-config.yaml \
		--format=pretty
	$(call log_this,"Running Kubectl in dry mode")
	kubectl \
		apply \
			--validate=true \
			--dry-run=client \
			-f $(PWD)/k8s
	$(call log_this,"DONE Running Kubectl in dry mode")

# database details
# (both docker and kubernetes)
DB_USER=postgres
DB_PSWD=pass01
DB_HOST?=localhost
DB_PORT?=5432
DB_NAME=flaskapp

# api details 
# (default values, this works both for Docker and a native Python process)
API_HOST_PORT?=localhost:5000

# docker details
DKR_VOL=flaskapp-db-volume
DKR_NET=flaskapp-network
DKR_DB_C_NAME=flaskapp-db-c
DKR_API_C_NAME=flaskapp-api-c

# kubernetes details
K8S_NAMESPACE=restapp
K8S_DB_SERVICE=db-service
K8S_REST_API_SERVICE=flaskapp-service

# colors
RED=\033[1;31m
GRN=\033[1;32m
YEL=\033[1;33m
MAG=\033[1;35m
CYN=\033[1;36m
NC=\033[0m

# logging details
LOG_UTC_TIMESTAMP := $$(date -u "+%Y-%m-%d %H:%M:%S")
LOG_PREFIX=$(CYN)$(LOG_UTC_TIMESTAMP) $(NC)$(RED)FlaskApp $(NC)

# logging function
define log_this
	@echo "$(LOG_PREFIX)$(YEL)$1$(NC)"
endef

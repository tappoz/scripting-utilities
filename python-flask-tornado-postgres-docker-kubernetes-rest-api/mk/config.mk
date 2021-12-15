# This applies to both:
# - Docker
# - Kubernetes
config-db:
	$(call log_this,"Configuring the Postgres DB at host $(DB_HOST):$(DB_PORT)")
	PGPASSWORD=$(DB_PSWD) psql \
		--username=$(DB_USER) \
		--host=$(DB_HOST) \
		--port=$(DB_PORT) \
		--command="DROP DATABASE IF EXISTS $(DB_NAME);"
	PGPASSWORD=$(DB_PSWD) psql \
		--username=$(DB_USER) \
		--host=$(DB_HOST) \
		--port=$(DB_PORT) \
		--command="CREATE DATABASE $(DB_NAME);"
	PGPASSWORD=$(DB_PSWD) psql \
		--username=$(DB_USER) \
		--host=$(DB_HOST) \
		--port=$(DB_PORT) \
		--command="ALTER DATABASE $(DB_NAME) SET log_statement = 'all';"
	PGPASSWORD=$(DB_PSWD) psql \
		--username=$(DB_USER) \
		--host=$(DB_HOST) \
		--port=$(DB_PORT) \
		--dbname=$(DB_NAME) \
		--echo-all \
		--file $(PWD)/sql/schema.sql
	$(call log_this,"DONE Configuring the Postgres DB at host $(DB_HOST):$(DB_PORT)")

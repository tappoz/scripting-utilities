docker-network:
	$(call log_this,"Making sure there is a Docker Network")
	-docker network create \
		--driver=bridge \
		$(DKR_NET)
	$(call log_this,"DONE Making sure there is a Docker Network")

docker-db:
	$(call log_this,"Making sure there is a Docker Volume")
	-docker volume create $(DKR_VOL)
	$(call log_this,"DONE Making sure there is a Docker Volume")
	$(call log_this,"Running a new Docker container for the Postgres DB")
	-docker stop $(DKR_DB_C_NAME)
	docker run \
		--rm \
		-d \
		--name $(DKR_DB_C_NAME) \
		--publish 5432:5432 \
		--volume $(DKR_VOL):/var/lib/postgresql/data \
		--network $(DKR_NET) \
		--env POSTGRES_PASSWORD=$(DB_PSWD) \
		postgres:12.6-alpine
	$(call log_this,"DONE Running a new Docker container for the Postgres DB")


# docker pull python:3.8.12-alpine3.14
# docker pull python:3.8
docker-build-http-api:
	$(call log_this,"Building the HTTP REST API Docker image")
	docker build . \
		--file flaskapp.Dockerfile \
		--network $(DKR_NET) \
		--tag flaskapp-i
	$(call log_this,"DONE Building the HTTP REST API Docker image")

docker-run-http-api:
	$(call log_this,"Running a new Docker container for the HTTP REST API")
	-docker stop $(DKR_API_C_NAME)
	docker run \
		-d \
		--rm \
		--name $(DKR_API_C_NAME) \
		--publish 5000:5000 \
		--env CONFENV=test \
		--env DB_HOST=$(DKR_DB_C_NAME) \
		--network $(DKR_NET) \
		flaskapp-i:latest
	$(call log_this,"DONE Running a new Docker container for the HTTP REST API")

docker-stop:
	$(call log_this,"Stopping and deleting all the Docker containers")
	-docker stop $(DKR_API_C_NAME)
	-docker stop $(DKR_DB_C_NAME)
	$(call log_this,"Deleting the Docker networks and volumes")
	-docker network rm $(DKR_NET)
	-docker volume rm $(DKR_VOL)
	$(call log_this,"DONE Stopping and deleting all the Docker containers and deleting the Docker networks and volumes")

docker-status:
	$(call log_this,"Showing all the Docker containers")
	-docker ps | grep -E '$(DKR_DB_C_NAME)|$(DKR_API_C_NAME)'
	$(call log_this,"Showing the Docker network")
	-docker network ls | grep $(DKR_NET)
	$(call log_this,"Showing the Docker volume")
	-docker volume ls | grep $(DKR_VOL)
	$(call log_this,"DONE Showing all the Docker resources")

docker-logs:
	$(call log_this,"Showing the logs for the DB Docker container")
	docker logs $(DKR_DB_C_NAME)
	$(call log_this,"DONE Showing the logs for the DB Docker container")
	$(call log_this,"Showing the logs for the HTTP REST API Docker container")
	docker logs $(DKR_API_C_NAME)
	$(call log_this,"DONE Showing the logs for the HTTP REST API Docker container")


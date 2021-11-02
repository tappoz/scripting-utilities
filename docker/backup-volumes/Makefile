# How to backup a Docker Volume for an existing 
# Postgres SQL database running as a Docker Container
#
# Docs:
# https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes
# https://hub.docker.com/_/postgres --> PGDATA environment variable
#
# The source code is at:
# https://github.com/tappoz/scripting-utilities/tree/master/docker/backup-volumes
#


DKR_VOL_1=my-db-volume1
DKR_VOL_2=my-db-volume2
DKR_CONT_NAME=my-db-instance
DKR_CONT_DATA_DIR=/var/lib/postgresql/data
DKR_CONT_PGDATA=/var/lib/postgresql/data/pgdata

DB_PSWD=test01
DB_HOST=localhost
DB_NAME=zztest

all:
# clean existing DB dumps and backups from the file system
	$(MAKE) clean-fs
# docker nuke existing containers and volumes
	$(MAKE) docker-nuke-stuff
# DB bootstrap within docker with a docker volume
	$(MAKE) db-up
# wait it's up and running
	$(MAKE) sleep
# 1st dump the SQL stuff of a clean environment
	$(MAKE) db-dump-fresh
# configure DBs, tables, data
	$(MAKE) db-configure
# 2nd dump the SQL stuff with the new DBs, tables, data (from SQL commands)
	$(MAKE) db-dump-after-config
# backup the docker volume
	$(MAKE) docker-backup
# docker nuke existing containers and volumes
	$(MAKE) docker-nuke-stuff
# restore the docker volume backup
	$(MAKE) docker-restore-backup
# reboot the docker container with the restored data
	$(MAKE) db-up2
# wait it's up and running
	$(MAKE) sleep
# 3rd dump the SQL stuff with the new DBs, tables, data (from Docker Volume restore)
	$(MAKE) db-dump-after-restore
# diff between the 2nd and the 3rd dump
	$(MAKE) diff-db

clean-fs:
	-mkdir -p $(PWD)/dump
	-mkdir -p $(PWD)/backup
	rm -rf $(PWD)/dump/*
	rm -rf $(PWD)/backup/*

# docker volume inspect <VOLUME_NAME> (old and new names)
docker-nuke-stuff:
# clean the docker container
	-docker stop $(DKR_CONT_NAME)
	-sleep 1
	-docker rm $(DKR_CONT_NAME)
# clean the docker volumes
	-docker volume rm $(DKR_VOL_1)
	-docker volume rm $(DKR_VOL_2)
# check what's left
	-docker ps -a | grep $(DKR_CONT_NAME)
	-docker volume ls | grep -E '$(DKR_VOL_1)|$(DKR_VOL_2)'
# create the docker volumes
	-docker volume create $(DKR_VOL_1)
	-docker volume create $(DKR_VOL_2)
	-docker volume ls | grep -E '$(DKR_VOL_1)|$(DKR_VOL_2)'

# Docker Container with the 1st Docker Volume
db-up:
	docker run -d \
		--name=$(DKR_CONT_NAME) \
		-p 5432:5432 \
		-v $(DKR_VOL_1):$(DKR_CONT_DATA_DIR) \
		-e PGDATA=$(DKR_CONT_PGDATA) \
		-e POSTGRES_PASSWORD=$(DB_PSWD) \
		postgres:12.6-alpine

# to allow for things to bootstrap
sleep:
	sleep 5

db-connect:
	PGPASSWORD=$(DB_PSWD) psql \
		-U postgres \
		-h $(DB_HOST)

db-dump-fresh:
	-mkdir -p $(PWD)/dump
	PGPASSWORD=$(DB_PSWD) pg_dumpall \
		-U postgres \
		-h $(DB_HOST) \
		--clean \
		-f $(PWD)/dump/01_fresh.sql

db-configure:
# drop DB idempotent (no errors)
	PGPASSWORD=$(DB_PSWD) psql \
		-U postgres \
		-h $(DB_HOST) \
		-c "DROP DATABASE IF EXISTS $(DB_NAME);"
# create DB idempotent (no errors)
	PGPASSWORD=$(DB_PSWD) psql \
		-U postgres \
		-h $(DB_HOST) \
		-c "CREATE DATABASE $(DB_NAME);"
# configure DB
	PGPASSWORD=$(DB_PSWD) psql \
		-U postgres \
		-h $(DB_HOST) \
		-c "ALTER DATABASE $(DB_NAME) SET log_statement = 'all';"
	PGPASSWORD=$(DB_PSWD) psql \
		-U postgres \
		-h $(DB_HOST) \
		-d $(DB_NAME) \
		-a \
		-f $(PWD)/schema.sql

db-dump-after-config:
	-mkdir -p $(PWD)/dump
	PGPASSWORD=$(DB_PSWD) pg_dumpall \
		-U postgres \
		-h $(DB_HOST) \
		--clean \
		-f $(PWD)/dump/02_after_config.sql

# docker pull ubuntu:20.04
docker-backup:
	mkdir -p $(PWD)/backup
	docker run \
		--rm \
		--volumes-from $(DKR_CONT_NAME) \
		-v $(PWD)/backup:/backup ubuntu:20.04 \
		bash -c "tar cf /backup/$(DKR_VOL_1).tar $(DKR_CONT_DATA_DIR)"

# new Docker Volume restoring a backup from the previous Docker Volume
# - the volumes have different names
# - the `--strip-components=4` option for `tar` allows to remove
#   this path prefix from the archive: `/var/lib/postgresql/data`
#   otherwise it will be restore with a double path `/var/lib/postgresql/data/var/lib/postgresql/data`
docker-restore-backup:
	docker volume create $(DKR_VOL_2)
	docker run \
		--rm \
		-v $(DKR_VOL_2):/restore \
		-v $(PWD)/backup:/backup ubuntu:20.04 \
		bash -c "tar xf /backup/$(DKR_VOL_1).tar --strip-components=4 -C /restore"

# Docker Container with the 2nd Docker Volume
db-up2:
	docker run -d \
		--name=$(DKR_CONT_NAME) \
		-p 5432:5432 \
		-v $(DKR_VOL_2):$(DKR_CONT_DATA_DIR) \
		-e PGDATA=$(DKR_CONT_PGDATA) \
		-e POSTGRES_PASSWORD=$(DB_PSWD) \
		postgres:12.6-alpine

db-dump-after-restore:
	-mkdir -p $(PWD)/dump
	PGPASSWORD=$(DB_PSWD) pg_dumpall \
		-U postgres \
		-h $(DB_HOST) \
		--clean \
		-f $(PWD)/dump/03_after_restore.sql

# there should be no diff between
# - the original Docker Container with the 1st Docker Volume
#   with data coming from the SQL statements
# - the new Docker Container with the 2nd Docker Volume
#   with data coming from the backup Tar file
diff-db:
	diff \
		$(PWD)/dump/02_after_config.sql \
		$(PWD)/dump/03_after_restore.sql


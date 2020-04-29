#!/bin/sh

DOCKER_MYSQL_PORT='3306' # NEEDED
DOCKER_MYSQL_USER='root' # NEEDED
DOCKER_MYSQL_PASSWORD='password' # NEEDED

DEV_MYSQL_PORT='3306' # NEEDED
DEV_MYSQL_HOST='127.0.0.1' # NEEDED
DEV_MYSQL_USER='root' # NEEDED
DEV_MYSQL_PASSWORD='password' # NEEDED

DATABASE_NAME='dbname' # NEEDED

echo "Start to backup from DEV database : ${DATABASE_NAME}"
docker exec mysql /usr/bin/mysqldump -h ${DEV_MYSQL_HOST} \
  -P ${DEV_MYSQL_PORT} \
  -u ${DEV_MYSQL_USER} \
  --password=${DEV_MYSQL_PASSWORD}! \
  ${DATABASE_NAME} >backup.sql

if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi

echo "Start to restore data into localhost : ${DOCKER_DATABASE_NAME}"
cat backup.sql | docker exec -i mysql /usr/bin/mysql -h localhost \
  -P ${DOCKER_MYSQL_PORT} \
  -u ${DOCKER_MYSQL_USER} \
  --password=${DEV_MYSQL_PASSWORD} ${DATABASE_NAME}

if [ $? -eq 0 ]; then
  echo "Restoration successfully completed"
else
  echo "Error found during restoration"

  echo "Delete backup.sql in local path"
  rm backup.sql
  exit 1
fi

echo "Delete backup.sql"
rm backup.sql

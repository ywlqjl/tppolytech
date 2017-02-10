#!/bin/bash


LOCAL_DIR=$(pwd)
DATA_DIR=$(printf "%s/datadir" ${LOCAL_DIR})

if [ -d "${DATA_DIR}" ]
then
	echo "${DATA_DIR} already exist"
else
	mkdir -p ${DATA_DIR}
fi

/usr/bin/docker run --name mysql \
    -v ${DATA_DIR}:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=password \
    -e MYSQL_DATABASE=wordpress \
    -e MYSQL_USER=wordpress \
    -e MYSQL_PASSWORD=password \
    -d mysql:5.7

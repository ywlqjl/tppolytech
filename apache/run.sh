#!/bin/bash

LOCAL_DIR=$(pwd)
WEB_DIR=$(printf "%s/wordpress" ${LOCAL_DIR})

if [ -d "${WEB_DIR}" ]
then
	sudo rm -rf ${WEB_DIR}
fi

wget --progress=dot http://wordpress.org/latest.tar.gz 

tar xfz latest.tar.gz

rm -f latest.tar.*

docker build -t tp2_web .

#touch ${WEB_DIR}/wp-config.php
#sudo chmod 644 ${WEB_DIR}/wp-config.php
#sudo chown www-data:www-data ${WEB_DIR}/wp-config.php
sudo chown -R www-data:www-data ${WEB_DIR}

/usr/bin/docker run --name wordpress \
    -v ${WEB_DIR}:/var/www/html \
    --rm \
    -P \
    -p 8080:80 \
    --link mysql:mysql \
    tp2_web

if [ -d "${WEB_DIR}" ]
then
	sudo rm -rf ${WEB_DIR}
fi

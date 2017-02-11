#!/bin/bash

#TRAEFIK_VERSION="v1.1.2"
#wget -q https://github.com/containous/traefik/releases/download/${TRAEFIK_VERSION}/traefik_linux-amd64 -O traefik
#chmod +x traefik
#./traefik -c traefik.toml

#docker run -d -p 8080:8080 -p 8090:8090 -v $PWD/traefik.toml:/etc/traefik/traefik.toml traefik

MY_IP=$(ip address show|grep inet|grep "scope global"|head -1 |awk '{print $2}'|awk -F\/ '{print $1}')
echo "${MY_IP}     tp4.polytech.fr" | sudo tee --append /etc/hosts

sudo rm -rf share/nginx/wordpress
sudo rm -rf share/mysql/data/*

wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz -C share/nginx/
rm -f latest.tar.*

sudo chown -R www-data:www-data share/nginx/wordpress

docker-compose up -d

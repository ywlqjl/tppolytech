#!/bin/bash

sudo rm -rf share/nginx/wordpress
sudo rm -rf share/mysql/data/*

wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz -C share/nginx/
rm -f latest.tar.*

sudo chown -R www-data:www-data share/nginx/wordpress

docker-compose up

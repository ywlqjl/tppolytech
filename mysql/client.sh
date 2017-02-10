#!/bin/bash

/usr/bin/docker run -it --link mysql:mysql \
    --rm mysql:5.7 /bin/bash \
    -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

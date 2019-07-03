#!/bin/sh
cd /var/www/vhosts/stiftungswo.ch/traefik/
docker-compose up -d

find ./*/ -name "docker-compose.yml" \
-exec bash -c 'docker-compose -f {} \
--project-name $(basename $(dirname $(dirname {})))_$(basename $(dirname {})) \
up -d --remove-orphans' \;

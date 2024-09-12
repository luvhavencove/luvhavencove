#!/bin/bash

# shellcheck disable=SC1091
source ".env"

# every day at 0 hours renew certbot and restart nginx
# crontab <<EOF
# 0 0 * * * /usr/local/bin/docker-compose --ansi never run certbot renew && $COMPOSE kill -s SIGHUP nginx
# EOF

# up docker compose

if [[ "$ENV" == "production" ]]; then
  docker compose up -d -f .\\docker-compose.yml -f .\\certbot\\docker-compose.yml
else
  docker compose up -d -f .\\docker-compose.yml
fi

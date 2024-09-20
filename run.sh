#!/bin/bash

# Usage of this script is optional

set -eou
if [[ -f $1 ]]; then
  source "$1"
  echo "Sourcing $1"
  export $(cat "$1")
else
  echo "Please source a .env file. Exiting"
  exit 1
fi

COMPOSE="/usr/local/bin/docker-compose"

# Cron job to renew TLS certs and restart NGINX container
CRON_JOB_1="0 0 * * * $COMPOSE run certbot renew && $COMPOSE exec nginx -s reload >/tmp/luvhavencove-logs/tls-dns.log 2>&1 # luvhavencove-tls-dns"

# if cronjob not already exists, add to crontab
if [[ ! "$(crontab -l | grep "# luvhavencove-tls-dns")" == *"# luvhavencove-tls-dns"* ]]; then
# lists current crontab and echos cron job to be added. Outputs errors to /dev/null. This combined output is piped into crontab to be installed
  (
    crontab -l 2>/dev/null
    echo "$CRON_JOB_1"
  ) | crontab -
fi

# docker compose
if [[ "$ENV" == "production" ]]; then
  docker compose -d --env-file=.env.production -f ./docker-compose.yml -f ./docker-compose.production.yml up
else
  docker compose -d -f ./docker-compose.yml up
fi

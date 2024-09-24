#!/bin/bash

COMPOSE="/usr/local/bin/docker-compose"

# Cron job to renew TLS certs and restart NGINX container
CRON_JOB_1="0 0 * * * $COMPOSE run certbot renew && $COMPOSE exec nginx -s reload >/app/logs/luvhavencove/tls-dns.log 2>&1 #certbot"

# if cronjob not already exists, add to crontab
if [[ ! "$(crontab -l | grep "#certbot")" == *"#certbot"* ]]; then
  # lists current crontab and echos cron job to be added. Outputs errors to /dev/null. This combined output is piped into crontab to be installed
  (
    crontab -l 2>/dev/null
    echo "$CRON_JOB_1"
  ) | crontab -
fi

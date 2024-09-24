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

./script/set-cronjobs.sh

# docker compose
if [[ "$ENV" == "production" ]]; then
  docker compose -d --env-file=.env.production -f ./docker-compose.yml -f ./docker-compose.production.yml up
else
  docker compose -d -f ./docker-compose.yml up
fi

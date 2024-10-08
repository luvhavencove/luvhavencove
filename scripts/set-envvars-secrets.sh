#!/bin/bash

project_root=$(realpath $(dirname "$(realpath $0)")/..)

echo "Note: If you have not set your environment variables in the .env files at the project root '$project_root', please do so, there are template files to start, and then rerun this script. Warning: This script sets environment variables and secrets exactly as defined in the project root $project_root/.env files."
read -p "Continue? (yY/*) " confirm
case "${confirm}" in
[yY]) ;;
*)
  exit 0
  ;;
esac

set -a

if [[ -f "$project_root/.env" ]]; then
  source "$project_root/.env"
  templates=$(echo $(find $project_root/secrets -maxdepth 1 -type f -name "*.template") $(find $project_root/luvhavencove-store -maxdepth 1 -type f -name ".env.template") $(find $project_root/luvhavencove-store-storefront -maxdepth 1 -type f -name ".env.template"))
  echo "Setting environment variables and secrets from .env"
  for template in ${templates}; do
    target=$(echo ${template} | sed 's#.template##')
    envsubst < ${template} >$target
    echo "Set $target"
  done
  echo "Finishing setting environment variables and secrets from .env"
fi

if [[ -f "$project_root/.env.production" ]]; then
  source "$project_root/.env.production"
  templates=$(echo $(find $project_root/secrets/production -maxdepth 1 -type f -name "*.template") $(find $project_root/luvhavencove-store -maxdepth 1 -type f -name ".env.production.template") $(find $project_root/luvhavencove-store-storefront -maxdepth 1 -type f -name ".env.production.template"))
  echo "Setting production environment variables and secrets from .env.production"
  for template in ${templates}; do
    target=$(echo ${template} | sed 's#.template##')
    envsubst < ${template} >$target
    echo "Set $target"
  done
  echo "Finishing setting production environment variables and secrets from .env.production"
fi

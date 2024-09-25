#!/bin/bash
# debug key

# Set API Key from shared volume file
NEXT_PUBLIC_SEARCH_API_KEY=$(cat /data/public/meilisearch_public_key)
export NEXT_PUBLIC_SEARCH_API_KEY

if [[ "$NODE_ENV" == "production" ]]; then
  echo "Running Storefront in 'production'."
  npm run build
  npm run start
else
  echo "Running Storefront in 'development'."
  npm run dev
fi

#!/bin/bash

# Load environment variables
MEILISEARCH_API_KEY=$(cat $MEILISEARCH_API_KEY)
export MEILISEARCH_API_KEY

# Run Medusa Seeding
# npx medusa seed -f ./data/seed.json || true

if [[ "$NODE_ENV" == "production" ]]; then
  echo "Running Backend in 'production'."
  npx medusa migrations run

  npm run start
else
  echo "Running Backend in 'development'."
  # Run Medusa Migrations
  npx medusa migrations run

  npx medusa user --id 1 --email $ADMIN_EMAIL --password $ADMIN_PASSWORD || true

  npm run dev
fi

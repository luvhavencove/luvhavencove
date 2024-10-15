#!/bin/bash

# Load environment variables
MEILISEARCH_API_KEY=$(cat $MEILISEARCH_API_KEY)
export MEILISEARCH_API_KEY
PAYPAL_CLIENT_SECRET=$(cat $PAYPAL_CLIENT_SECRET)
export PAYPAL_CLIENT_SECRET
STRIPE_API_KEY=$(cat $STRIPE_API_KEY)
export STRIPE_API_KEY
PAYPAL_CLIENT_SECRET=$(cat $PAYPAL_CLIENT_SECRET)
export STRIPE_WEBHOOK_SECRET

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

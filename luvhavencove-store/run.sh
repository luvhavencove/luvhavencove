#!/bin/bash

# Remove existing Meilisearch Public API key
if [[ -f /data/public/meilisearch_public_key ]]; then
  rm /data/public/meilisearch_public_key
fi

# Obtain Meilisearch Public API key
curl -X GET "$MEILISEARCH_HOST/keys" \
  -H "Authorization: Bearer $(cat "$MEILISEARCH_API_KEY")" \
  -s |
  jq ".results[0].key" |
  sed 's/"//g' >/data/public/meilisearch_public_key

# Run Medusa Seeding
# npx medusa seed -f ./data/seed.json

if [[ "$1" == "production" ]]; then
  echo "Running Backend in 'production'."
  npm run start
else
  echo "Running Backend in 'development'."
  # Run Medusa Migrations
  npx medusa migrations run

  npx medusa user --id 1 --email admin@luvhavencove.com --invite || true

  npm run dev && npm run dev:admin
fi

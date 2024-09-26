#!/bin/bash

# Remove existing Meilisearch Public API key
if [[ -f /data/public/meilisearch_public_key ]]; then
  # Removing existing public key
  rm /data/public/meilisearch_public_key
fi

if [[ ! -f $MEILISEARCH_API_KEY ]]; then
  echo "No Meilisearch API Key file"
else 
  echo "Discovered Meilisearch API Key file"
fi

# Obtain new Meilisearch Public API key
curl -X GET "$MEILISEARCH_HOST/keys" \
  -H "Authorization: Bearer $(cat $MEILISEARCH_API_KEY)" \
  -s |
  jq ".results[0].key" |
  sed 's/"//g' >/data/public/meilisearch_public_key

if [[ -f /data/public/meilisearch_public_key ]] &&
  [[ $(cat /data/public/meilisearch_public_key | wc -c) -gt 0 ]]; then
  echo "Populated Meilisearch Public Key"
  exit 0
fi

echo "Meilisearch Public Key not found or is empty"
exit 1

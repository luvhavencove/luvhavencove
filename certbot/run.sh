#!/bin/bash

certbot certonly \
  --agree-tos \
  --email $CLOUDFLARE_EMAIL \
  --non-interactive \
  --dns-cloudflare \
  --dns-cloudflare-credentials "/run/secrets/cloudflare_api_token.ini" \
  --dns-cloudflare-propagation-seconds 60 \
  -d "$DOMAIN" \
  -d "www.$DOMAIN" \
  -d "api.$DOMAIN" \
  -d "admin.$DOMAIN"

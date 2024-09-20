#!/bin/bash

# NGINX directory
NGINX_DIR="/etc/nginx"

# Create Diffie-Hellman key if it does not already exists
if [[ ! -e $NGINX_DIR/dhparam.pem ]]; then
     echo "DH parameters not found. Generating DH parameters..."
     openssl dhparam -out $NGINX_DIR/dhparam.pem 2048
fi

# Get NGINX config by ENV case
CONF_FILE="luvhavencove.$(case "$ENV" in
     production) echo com ;;
     *) echo local ;;
     esac).conf"

# Remove unnecessary default.conf
DEFAULT_CONF_FILE=$NGINX_DIR/conf.d/default.conf
if [[ -e $DEFAULT_CONF_FILE ]]; then
     echo "Detected default.conf. Deleting..."
     rm $DEFAULT_CONF_FILE
fi

# Enable site
ln -sf $NGINX_DIR/sites-available/$CONF_FILE \
     $NGINX_DIR/sites-enabled/$CONF_FILE

if [[ ! "$ENV" == "production" ]]; then
     echo "Not in production."
else
     CERT_DIR="/etc/letsencrypt/live/luvhavencove.com"
     CERT_FILES=("chain.pem" "fullchain.pem" "privkey.pem")

     echo "Obtaining certifications..."
     # wait until Certbot obtains certs
     echo "Waiting for certificates..."
     for cert in "${CERT_FILES[@]}"; do
          until [ -f "$CERT_DIR/$cert" ]; do
               echo "Waiting for $cert..."
               sleep 500
          done
     done

     # Uncomment SSL directives in NGINX config
     echo "Enabling SSL in NGINX configuration..."
     sed -i -r 's/; # ssl/ ssl/g' $NGINX_DIR/sites-enabled/$CONF_FILE

     echo "In production"
fi

# Reload NGINX
echo "Start NGINX..."
nginx -t && nginx -t && nginx -g "daemon off;"

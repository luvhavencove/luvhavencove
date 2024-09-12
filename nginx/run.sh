#!/bin/bash

# Get the directory of the script
NGINX_DIR="/etc/nginx"
CONFIG_FILE="luvhavencove.com.conf"

# create dh key if it does not already exists
if [[ ! -e $NGINX_DIR/dhparam.pem ]]; then
     echo "DH parameters not found. Generating DH parameters..."
     openssl dhparam -out $NGINX_DIR/dhparam.pem 2048
fi

# Exit if not production
if [[ ! "$ENV" == "production" ]]; then
     # Rewrite server block to localhost
     find "/etc/nginx" -type f -name "$CONFIG_FILE" -exec \
          sed -i -r -e 's/(server_name\s+(www)?\.)luvhavencove\.com/\1localhost/g' \
          -e 's/(ssl_(trusted_)?certificate(_key)?)/# \1/g' \
          {} +
     find "/etc/nginx" -type f -name "$CONFIG_FILE" -exec \
          perl -0777 -pe \
          's/(location \/ {)([^}]*?)(})/include nginxconfig\.io\/reverseproxy\.conf;/g' \
          {} +
     find "/etc/nginx" -type f -name "default.conf" -exec \
          rm {} +
     echo "Not in production."
     # Reload NGINX
     echo "Start NGINX..."
     nginx -t && nginx -g "daemon off;"
     tail -f /var/log/nginx/error.log /var/log/nginx/rewrite.log
     sleep infinity
fi

CERT_DIR="/etc/letsencrypt/live/luvhavencove.com"
CERT_FILES=("cert.pem" "chain.pem" "fullchain.pem" "privkey.pem")

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
sed -i -r 's/; # ssl/ ssl/g' "$CONFIG_FILE"

# Reload NGINX
echo "Start NGINX..."
nginx -t && nginx -t && nginx -g "daemon off;"

sleep infinity

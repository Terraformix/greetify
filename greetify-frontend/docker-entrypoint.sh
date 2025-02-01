#!/bin/sh

echo "Configuration Settings passed in via Docker ENV:"
echo "VITE_IS_STATIC: $VITE_IS_STATIC"
echo "VITE_APP_API_URL: $VITE_APP_API_URL"

if [ "$VITE_IS_STATIC" = "true" ]; then
    export PROXY_CONFIG=""
else
    export PROXY_CONFIG="
    location /api/ {
        proxy_pass ${VITE_APP_API_URL};
        proxy_ssl_name \$host;
        proxy_ssl_server_name on;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }"
fi

echo "PROXY_CONFIG: $PROXY_CONFIG"
# < specifies the input file, > specifies the output file (Location in the container)
envsubst '${PROXY_CONFIG}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"
#!/usr/bin/env bash

SAMPLE_RANDOM_PASS="my-uuid-string-or-other-silly-words"
SAMPLE_DOMAIN="placeholder.example.com"
PINGPONG_HTML_URL="https://raw.githubusercontent.com/ofcyln/one-html-page-challenge/master/entries/ping-pong.html"

[[ -z "${TROJAN_PASSWORD}" ]] && { read -r -p "Specify Trojan Pass: (e.g.: default random pass [${SAMPLE_RANDOM_PASS}])" TROJAN_PASSWORD; }
[[ -z "${DOMAIN_NAME}" ]] && { read -r -p "Specify Domain name: (e.g.: ${SAMPLE_DOMAIN})" DOMAIN_NAME; }

SSL_DIR="/ssl/${DOMAIN_NAME}"
SSL_CERT_PATH="${SSL_DIR}/${DOMAIN_NAME}.crt"
SSL_KEY_PATH="${SSL_DIR}/${DOMAIN_NAME}.key"

echo "Generate Caddy file"
mkdir -p ./caddy
cat > ./caddy/Caddyfile <<-EOF
${DOMAIN_NAME}:80 {
    root /usr/src/trojan
    log /usr/src/caddy.log
    index index.html
}
${DOMAIN_NAME}:443 {
    root /usr/src/trojan
    log /usr/src/caddy.log
    index index.html
}
EOF

echo "Generate trojan-go config"
mkdir -p ./trojan-go
cat > ./trojan-go/config.json <<-EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "caddy",
    "remote_port": 80,
    "password": [
        "$TROJAN_PASSWORD"
    ],
    "ssl": {
        "cert": "$SSL_CERT_PATH",
        "key": "$SSL_KEY_PATH",
        "sni": "$DOMAIN_NAME"
    },
    "mux": {
        "enabled": true
    }
}
EOF

echo "prepare index.html"
mkdir -p ./wwwroot/trojan
echo "" > ./wwwroot/caddy.log
curl $PINGPONG_HTML_URL -o ./wwwroot/trojan/index.html


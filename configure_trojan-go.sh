#!/usr/bin/env bash

SAMPLE_RANDOM_PASS=$(uuidgen)
SAMPLE_DOMAIN='placeholder.example.com'

read -r -p "Specify Trojan Pass: (e.g.: default random pass [${SAMPLE_RANDOM_PASS}])" trojan_passwd
read -r -p "Specify Domain name: (e.g.: ${SAMPLE_DOMAIN})" your_domain
[[ -z $trojan_passwd ]] && { trojan_passwd="$SAMPLE_RANDOM_PASS"; }
[[ -z $your_domain ]] && { your_domain="$SAMPLE_DOMAIN"; }

SSL_CERT_PATH="/ssl/${your_domain}/${your_domain}.crt"
SSL_KEY_PATH="/ssl/${your_domain}/${your_domain}.key"

echo "Generate Caddy file"

cat > ./caddy/Caddyfile <<-EOF
${your_domain}:80 {
    root /usr/src/trojan
    log /usr/src/caddy.log
    index index.html
}
${your_domain}:443 {
    root /usr/src/trojan
    log /usr/src/caddy.log
    index index.html
}
EOF

echo "Generate trojan-go config"
cat > ./trojan-go/config.json <<-EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "caddy",
    "remote_port": 80,
    "password": [
        "$trojan_passwd"
    ],
    "ssl": {
        "cert": "$SSL_CERT_PATH",
        "key": "$SSL_KEY_PATH",
        "sni": "$your_domain"
    }
    "mux": {
        "enabled": true
    }
}
EOF
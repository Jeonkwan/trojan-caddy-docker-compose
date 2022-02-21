#!/usr/bin/env bash

SAMPLE_RANDOM_PASS=$(uuidgen)
SAMPLE_DOMAIN='helloworld.example.com'

read -r -p "Specify Trojan Pass: (e.g.: default random pass [${SAMPLE_RANDOM_PASS}])" trojan_passwd
read -r -p "Specify Domain name: (e.g.: ${SAMPLE_DOMAIN})" your_domain

[[ -z $trojan_passwd ]] && { trojan_passwd="$SAMPLE_RANDOM_PASS"; }

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

cat > ./trojan/config/config.json <<-EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "caddy",
    "remote_port": 80,
    "password": [
        "$trojan_passwd"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/ssl/$your_domain/$your_domain.crt",
        "key": "/ssl/$your_domain/$your_domain.key",
        "key_password": "",
        "cipher": "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256",
        "prefer_server_cipher": true,
        "alpn": [
            "http/1.1"
        ],
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": ""
    },
    "tcp": {
        "prefer_ipv4": false,
        "no_delay": true,
        "keep_alive": true,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": ""
    }
}
EOF
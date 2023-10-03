#!/usr/bin/env sh

/usr/bin/caddy \
    --conf /etc/Caddyfile \
    --log stdout \
    --agree=true &

# wait for caddy
sleep 5m

/opt/trojan-go/trojan-go \
    -config /etc/trojan-go/config.json

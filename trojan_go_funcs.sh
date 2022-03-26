#!/usr/bin/env bash

function run_trojan_go {
    docker-compose -d -f docker-compose_trojan-go.yml up
}

function clean_up_trojan_go {
    docker-compose -f docker-compose_trojan-go.yml down
    rm -rf {./caddy,./trojan-go,./wwwroot,./ssl}
}
#!/usr/bin/env bash

# one shot task, removed flag -e "INTERVAL=10s"
SAMPLE_DOMAIN="example.com"
SAMPLE_SUBDOMAIN="sub1"

read -r -p "Domain name(e.g.: ${SAMPLE_DOMAIN}): " DOMAIN
read -r -p "Subdomain name(e.g.: ${SAMPLE_SUBDOMAIN}): " SUBDOMAIN
read -r -p "Instance public IP address: " INSTANCE_PUBLIC_IP
read -s -r -p "Namecheap Dynamice DNS Password: " NAMECHEAP_DDNS_PASS
echo ""

function update_nc_dns_curl {
    curl "https://dynamicdns.park-your-domain.com/update?host=${SUBDOMAIN}&domain=${DOMAIN}&password=${NAMECHEAP_DDNS_PASS}&ip=${INSTANCE_PUBLIC_IP}"
}

function update_nc_dns_docker {
    docker run \
    --name namecheap-ddns-update \
    --rm \
    -e "DOMAIN=${DOMAIN}" \
    -e "SUBDOMAINS=${SUBDOMAIN}" \
    -e "IP=${INSTANCE_PUBLIC_IP}" \
    -e "NC_DDNS_PASS=${NAMECHEAP_DDNS_PASS}" \
    joshuamorris3/namecheap-ddns-update
}

# by default using the docker method
update_nc_dns_docker
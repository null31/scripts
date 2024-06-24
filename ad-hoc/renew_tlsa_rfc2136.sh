#!/usr/bin/env bash

# update TLSA records where entries are formated as array
# it uses RFC2136 DNS Update to update your zone

NS_IP=${IP or hostname of your master Name Server}
NS_PORT=53
TSIG_NAME="hmac-sha256:tsig_name"
TSIG_KEY="tsig_key=="
TLSA_VALUE=$(/opt/scripts/generate_tlsa.sh /etc/letsencrypt/live/example.com/fullchain.pem)
RR_NAMES=(_25._tcp.example.com _443._tcp.example.com _993._tcp.example.com)

for i in "${!RR_NAMES[@]}"; do
	nsupdate <<!
	server ${NS_IP} ${NS_PORT}
	zone example.com
	update delete ${i} TLSA
	update add ${i} 3600 TLSA 3 1 1 ${TLSA_VALUE}
	key ${TSIG_NAME} ${TSIG_KEY}
	send
	!
done

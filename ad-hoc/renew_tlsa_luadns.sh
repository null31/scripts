#!/usr/bin/env bash

# update TLSA records where entries are formated as array
# it uses LuaDNS API to update your zone
# it's necessary to set the records as ignore to prevent modification from builder system
# see docs https://luadns.com/help.html#ignore
# example: ignore("%._tcp", "TLSA")
#
# Use this to get your Zone ID
# curl -u user@email.com:012abc -H 'Accept: application/json' https://api.luadns.com/v1/zones | jq
#
# And this to get the records ID
# curl -u user@email.com:012abc -H 'Accept: application/json' https://api.luadns.com/v1/zones/012 | jq

USER=user@email.com
KEY=012abc
RR=(_25._tcp.example.com. _443._tcp.example.com.)
IDS=(123 456) # these IDs must match the order you wrote the records above to prevent update the wrong records and return error
CERT_HASH=$(/opt/scripts/gen_tlsa.sh /etc/letsencrypt/live/example.com/fullchain.pem)
ZONE=012

for i in "${!RR[@]}"; do
	curl -s -u ${USER}:${KEY} -H 'Accept: application/json' \
	-X PUT \
	-d "{ \"name\": \"${RR[i]}\", \"type\": \"TLSA\", \"content\": \"3 1 1 ${CERT_HASH}\", \"ttl\": 3600 }" \
	https://api.luadns.com/v1/zones/${ZONE}/records/${IDS[i]}
done

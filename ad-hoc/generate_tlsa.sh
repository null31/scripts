#!/usr/bin/env bash

# generate the hash used for TLSA RRs on DNS
# example of record: TLSA "3 1 1 ${hash}"

openssl x509 -noout -pubkey -in $1 -outform DER | \
openssl ec -pubin -pubout -outform DER 2>/dev/null | \
openssl sha256 | \
cut -d ' ' -f 2

#!/usr/bin/env bash

###
# This script create a backup of an email directory and send to a remote server using Borg
###

## set variables
BKP_DIR='mail'
DATE=$(date +%F_%H%M)
DST_FILE="bkp_email_${DATE}.tar.zst"

## go to home directory and remove previous backup
cd /home
rm ./bkp_email*

## create a compact backup with integrity hash
ZSTD_CLEVEL=12 tar --zstd -cpf ${DST_FILE} ${BKP_DIR}
sha256sum ${DST_FILE} > ${DST_FILE}.sha256

## call Borg to send backup to a remote server
/root/borg_backup.sh email "${DST_FILE}*"

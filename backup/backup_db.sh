#!/usr/bin/env bash

###
# This script create a backup from MariaDB databases and use Borg to send to a remote server
###

## set variables
BKP_DIR=/tmp/bkp_db
MYSQL_USER='SOME_USER'
MYSQL_PW='SOME_PW'
DATE=$(date +%F_%H%M)
DSTFILE="PREFIX_NAME_${DATE}.tar.zst"

## create temporary backup directory
mkdir -p ${BKP_DIR}

## dump databases
mariadb-dump -u ${MYSQL_USER} --password=${MYSQL_PW} --dump-date -B some_db > ${BKP_DIR}/some_db.sql

## create a compact backup with integrity hash
cd /tmp
ZSTD_CLEVEL=12 tar --zstd -cf ${DSTFILE} ${BKP_DIR}
sha256sum ${DSTFILE} > ${DSTFILE}.sha256

## call Borg to send backup to a remote server
/root/borg_backup.sh db "/tmp/${DST_FILE}*"

rm -rf ${BKP_DIR} ${DSTFILE}*

#!/usr/bin/env bash

###
# This script create and remove backups using Borg, where the remote Borg is a Hetzner's Storage Box.
###

## set environment variables

LOG='/var/log/borg/backup.log'
export BORG_RSH='ssh -J some_bastion'
export BORG_PASSPHRASE='SOME_PASSPHRASE'
export REPOSITORY_DIR='INSERT_YOUR_DIR'
export REPOSITORY="ssh://INSERT_YOUR_DST_HOST/./INSERT_YOUR_DESIRED_REMOTE_DIR/${REPOSITORY_DIR}"
export BKP_TYPE="${1}"
export FILE_LIST="${2}"

## Output to a logfile
exec > >(tee -i ${LOG})
exec 2>&1

echo "###### Backup started: $(date) ######"
echo "Transfer files ..."
borg create -v --stats \
 ${REPOSITORY}::${BKP_TYPE}-'{now:%Y-%m-%d_%H:%M}' \
 ${FILE_LIST}
echo "###### Backup ended: $(date) ######"

echo "###### Backup cleanup, keep last 3: $(date) ######"
borg prune -v --list --keep-last 3 -P ${BKP_TYPE} ${REPOSITORY}
borg compact -v ${REPOSITORY}
echo "###### Backup cleanup ended: $(date) ######"

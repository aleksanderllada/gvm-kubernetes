#!/bin/bash

# Make sure empty volumes are actually empty
rm -rf /usr/local/var/lib/gvm/data-objects/lost+found
rm -rf /usr/local/var/lib/gvm/scap-data/lost+found
rm -rf /usr/local/var/lib/gvm/cert-data/lost+found

if [ -z "$(ls -A /usr/local/var/lib/gvm/data-objects)" ] || [ "$1" == "--resync" ];
then
  echo "Syncing GVMD data."
  greenbone-feed-sync --type GVMD_DATA
else
  echo "GVMD data already present."
fi

if [ -z "$(ls -A /usr/local/var/lib/gvm/scap-data)" ] || [ "$1" == "--resync" ];
then
  echo "Syncing SCAP data."
  greenbone-feed-sync --type SCAP
else
  echo "SCAP data already present."
fi

if [ -z "$(ls -A /usr/local/var/lib/gvm/cert-data)" ] || [ "$1" == "--resync" ];
then
  echo "Syncing CERT data."
  greenbone-feed-sync --type CERT
else
  echo "CERT data already present."
fi

exit 0

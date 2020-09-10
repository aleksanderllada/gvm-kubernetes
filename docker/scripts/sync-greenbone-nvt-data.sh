#!/bin/bash

# Make sure empty volumes are actually empty
rm -rf /usr/local/var/lib/openvas/plugins/lost+found

if [ -z "$(ls -A /usr/local/var/lib/openvas/plugins)" ] || [ "$1" == "--resync" ];
then
  echo "Syncing NVT data."
  su - gvm bash -c greenbone-nvt-sync
else
  echo "NVT data already present."
fi

exit 0

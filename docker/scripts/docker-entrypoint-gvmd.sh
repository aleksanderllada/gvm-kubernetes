#!/bin/bash

# Symlink gvmd logs to stdout
mkdir -p /usr/local/var/log/gvm
touch /usr/local/var/log/gvm/gvmd.log
ln -sf /proc/1/fd/1 /usr/local/var/log/gvm/gvmd.log

# Initialize the database.
echo "Initializing the database."

useradd postgres
su - postgres -c "createuser -DRS root"
su - postgres -c "createdb -O root gvmd"
su - postgres -c "psql -c 'create role dba with superuser noinherit;'"
su - postgres -c "psql -c 'grant dba to root;'"
su - postgres -c "psql -d gvmd -c 'create extension \"uuid-ossp\";'"
su - postgres -c "psql -d gvmd -c 'create extension \"pgcrypto\";'"

# Migrate database.
if [ "$MIGRATE_DATABASE" == "true" ];
then
  gvmd --migrate
fi

# Create user if the environment variables are present.
if [ -v ADMIN_USERNAME ] && [ -v ADMIN_PASSWORD ];
then
  gvmd --create-user=$ADMIN_USERNAME --password=$ADMIN_PASSWORD --role=Admin 
  
  # Set the Feed Import Owner
  if [ $? -eq 0 ]; then
    USER_ID=`gvmd --get-users --verbose | grep $ADMIN_USERNAME | awk '{print $2}'`
    gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value $USER_ID
  fi
fi

# Setup the default OpenVAS scanner if the environment variables are present.
if [ -v OPENVAS_SCANNER_HOST ] && [ -v OPENVAS_SCANNER_PORT ];
then
  OPENVAS_SCANNER_ID=`gvmd --get-scanners | grep "OpenVAS Default" | awk '{print $1}'`
  gvmd --modify-scanner=$OPENVAS_SCANNER_ID --scanner-host=$OPENVAS_SCANNER_HOST --scanner-port=$OPENVAS_SCANNER_PORT
fi

# Main entrypoint
_term() { 
  echo "Caught SIGTERM signal. Exiting." 
  kill -TERM "$child" 2>/dev/null
}

trap _term TERM
gvmd --foreground "$@" &

pid=$! 
wait "$pid"

#!/bin/bash

set -e

if [ -v PGDATA ] && [ ! -d $PGDATA ];
then
  /usr/lib/postgresql/11/bin/initdb -D $PGDATA
fi

chmod -R 0700 $PGDATA

# Main entrypoint
_term() { 
  echo "Caught SIGTERM signal. Exiting." 
  kill -INT "$child" 2>/dev/null # SIGINT for Fast Shutdown mode.
}

trap _term TERM

/usr/lib/postgresql/11/bin/postgres "$@" &

pid=$! 
wait "$pid"

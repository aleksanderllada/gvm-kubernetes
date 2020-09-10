#!/bin/sh

# Symlink gsad logs to stdout 
mkdir -p /usr/local/var/log/gvm
touch /usr/local/var/log/gvm/openvas.log
ln -sf /proc/1/fd/1 /usr/local/var/log/gvm/openvas.log

# Main entrypoint
_term() { 
  echo "Caught SIGTERM signal. Exiting." 
  kill -TERM "$child" 2>/dev/null
}

trap _term TERM
ospd-openvas --foreground "$@" &

pid=$! 
wait "$pid"

#!/bin/sh

NPROC=$(nproc)

if [ "$NPROC" -ge 2 ]; then
  trap "echo 'Shutting down' && /opt/antidote/bin/env stop" TERM
  /opt/antidote/bin/env start && sleep 10 && tail -f /opt/antidote/log/console.log &
  sleep 10 && cd /opt/AQL && ./rebar3 shell --name=$AQL_NAME --setcookie antidote 
else
  echo "You need at least 2 cpu cores in your Docker (virtual) machine to run this image!"
  echo "You have ${NPROC} processors"
  exit 1
fi
#!/bin/bash

if [ "$1" != "sync" ]
then
  /usr/sbin/sshd -D
fi

server=$2
port=$3

while true
do
  sync_errors=0

  for arg in "${@:4}"
  do
    echo "$(date) syncing $arg to $server:$port"

    if ! rsync -av --numeric-ids --delete -e "ssh -o StrictHostKeyChecking=no -p $port" "$arg" "$server:${arg// /\\ }" >> /sync.log
    then
      sync_errors=1
    fi
  done

  if [ 0 -eq $sync_errors ]
  then
    echo "$(date) sync complete"
  else
    echo "$(date) sync completed with errors"
  fi

  sleep 5
done

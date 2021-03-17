#!/bin/bash
set -xe

if [ "$RAILS_ENV" == "development" ]; then
  ./wait-for-it.sh --strict --timeout=0 localstack:4566 -- echo '[+] Localstack is up'
fi

rm -f /app/tmp/pids/server.pid

exec "$@"

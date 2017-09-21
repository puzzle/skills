#!/usr/bin/env bash

export RAILS_PORT=3001

rails server -e test -d -p $RAILS_PORT

cd frontend
COVERAGE=true yarn test
rc=$?
cd ..

kill -INT $(cat tmp/pids/server.pid)

exit $rc

#!/usr/bin/env bash

export RAILS_PORT=3001

rails server -e test -d -p $RAILS_PORT

cd frontend && COVERAGE=true ember test
cd ..

kill -INT $(cat tmp/pids/server.pid)

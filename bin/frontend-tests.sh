#!/usr/bin/env bash

export RAILS_PORT=3001

rails server -e test -d -p $RAILS_PORT -P tmp/pids/frontend-test-server.pid
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

cd frontend
COVERAGE=true ember test --server
rc=$?
cd ..

kill -INT $(cat tmp/pids/frontend-test-server.pid)

exit $rc

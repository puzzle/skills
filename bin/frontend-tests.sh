#!/usr/bin/env bash

export MOCK_LDAP_AUTH=1
export RAILS_PORT=3001
export FRONTEND_TESTS=1
PID_FILE=tmp/pids/frontend-test-server.pid
SERVER=false

case $1 in
  's' | 'serve' | 'server')
    SERVER=true ;;
esac

rails server -e test -d -p $RAILS_PORT -P $PID_FILE
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

cd frontend
if [[ $SERVER == true ]]; then
  COVERAGE=true ember test --server
else
  COVERAGE=true yarn test
fi
rc=$?
cd ..

kill -INT $(cat $PID_FILE)

exit $rc

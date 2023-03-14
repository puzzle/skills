#!/bin/bash
# this file is overwritten by docker development setup (see docker-compose.yml)
rm -f public/frontend-index-test.html
cp -rf frontend/dist/* public/
mv public/{index,frontend-index-test}.html

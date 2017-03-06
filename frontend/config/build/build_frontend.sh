#!/bin/bash

npm install -g bower
npm install
bower install

npm run build-prod

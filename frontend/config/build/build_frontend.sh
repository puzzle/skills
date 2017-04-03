#!/bin/bash

npm install bower && \
npm install && \
npm run bower-install && \
npm run build-prod

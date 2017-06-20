#!/bin/bash

yarn add bower && \
yarn install && \
yarn run bower-install && \
yarn run build-prod

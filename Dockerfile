#################################
#          Build Stage          #
#################################

FROM ruby:2.7 AS build

# Use root user
USER root

ARG BUILD_PACKAGES
ARG YARN_VERSION=1.22.10
ARG BUNDLER_VERSION=2.2.16

# Install dependencies
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
       libpq-dev nodejs npm \
       ${BUILD_PACKAGES} \
    && npm install -g npm

# Install specific versions of dependencies
RUN npm install yarn -g && yarn set version ${YARN_VERSION}
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# TODO: Load artifacts

# set up app-src directory
COPY . /app-src
WORKDIR /app-src

# Run deployment
RUN    yarn install \
    && bundle config set --local deployment 'true' \
    && bundle package \
    && bundle install

# TODO: Save artifacts
# TODO: Maybe delete vendor/cache? -20M

#################################
#           Run Stage           #
#################################

# This image will be replaced by Openshift
FROM ruby:2.7-slim AS app

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "" app

ARG RUN_PACKAGES

# Install dependencies, remove apt!
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
       imagemagick libpq5 vim-tiny curl git \
       ${RUN_PACKAGES}

# Copy deployment ready source code from build
COPY --from=build /app-src /app-src
WORKDIR /app-src

# Set group permissions to app folder
RUN    chgrp -R 0 /app-src \
    && chmod -R u+w,g=u /app-src

ENV HOME=/app-src

# Use cached gems
RUN    bundle config set --local deployment 'true'
    && bundle

USER 1001

ENTRYPOINT ["bundle", "exec", "puma", "-t", "8"]

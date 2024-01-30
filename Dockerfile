#################################
#          Build Stage          #
#################################

FROM ruby:3.2 AS build

# Set build shell
SHELL ["/bin/bash", "-c"]

# Use root user
USER root
ENV NODE_VERSION=14.21.3
ARG BUILD_PACKAGES
ARG BUILD_SCRIPT
ARG BUNDLE_WITHOUT='development:metrics:test'
ARG BUNDLER_VERSION=2.4.6
ARG POST_BUILD_SCRIPT


RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN bash -vxc "node -v"

# Install dependencies
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y ${BUILD_PACKAGES}


RUN bash -vxc "${BUILD_SCRIPT:-"echo 'no BUILD_SCRIPT provided'"}"

# Install specific versions of dependencies
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# TODO: Load artifacts

# set up app-src directory
COPY . /app-src
WORKDIR /app-src

# Run deployment
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT} \
    && bundle config set --local path vendor/bundle \
    && bundle package \
    && bundle install \
    && bundle clean

RUN bash -vc "${POST_BUILD_SCRIPT:-"echo 'no POST_BUILD_SCRIPT provided'"}"

# TODO: Save artifacts

RUN rm -rf vendor/cache/ .git

#################################
#           Run Stage           #
#################################

# This image will be replaced by Openshift
FROM ruby:3.2 AS app

# Set runtime shell
SHELL ["/bin/bash", "-c"]

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "" app

ARG BUNDLE_WITHOUT='development:metrics:test'
ARG RUN_PACKAGES
ARG BUNDLER_VERSION=2.4.6

# Install specific versions of dependencies
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# Install dependencies, remove apt!
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y ${RUN_PACKAGES} \
    && apt-get install ca-certificates

# Copy deployment ready source code from build
COPY --from=build /app-src /app-src
WORKDIR /app-src

# Set group permissions to app folder
RUN    chgrp -R 0 /app-src \
    && chmod -R u+w,g=u /app-src

ENV HOME=/app-src

# Use cached gems
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT} \
    && bundle config set --local path vendor/bundle \
    && bundle

USER 1001

CMD ["bundle", "exec", "puma", "-t", "8"]

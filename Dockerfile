#################################
#          Variables            #
#################################

# Versioning
ARG RUBY_VERSION="3.2"
ARG BUNDLER_VERSION="2.4.6"
ARG NODEJS_VERSION="16"
ARG YARN_VERSION="1.22.19"

# Packages
ARG BUILD_PACKAGES="libpq-dev npm build-essential"
ARG RUN_PACKAGES="git imagemagick libpq5 libjemalloc-dev libjemalloc2"

# Scripts
ARG PRE_INSTALL_SCRIPT=" \
     curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x -o /tmp/nodesource_setup.sh \
  && bash /tmp/nodesource_setup.sh \
"
ARG INSTALL_SCRIPT="node -v && npm -v && npm install -g yarn && yarn set version ${YARN_VERSION}"
ARG PRE_BUILD_SCRIPT
ARG BUILD_SCRIPT="yarn install"
ARG POST_BUILD_SCRIPT=" \
     cd frontend \
  && yarn install --no-progress \
  && yarn build-prod \
  && mv -v dist/* ../public \
  && echo \"(built at: $(date '+%Y-%m-%d %H:%M:%S'))\" > /${HOME}/BUILD_INFO \
"

# Bundler specific
ARG BUNDLE_WITHOUT="development:metrics:test"

# App specific
ARG RAILS_ENV="production"
ARG RACK_ENV="production"
ARG NODE_ENV="production"
ARG RAILS_HOST_NAME="unused.example.net"
ARG SECRET_KEY_BASE="needs-to-be-set"

# Runtime ENV vars
ARG HOME=/app-src
ARG PS1="[\${SENTRY_CURRENT_ENV}] `uname -n`:\${PWD}\$ "
ARG TZ="Europe/Zurich"

#################################
#          Build Stage          #
#################################

FROM ruby:${RUBY_VERSION} AS build

# arguments for steps
ARG PRE_INSTALL_SCRIPT
ARG BUILD_PACKAGES
ARG INSTALL_SCRIPT
ARG BUNDLER_VERSION
ARG PRE_BUILD_SCRIPT
ARG BUNDLE_WITHOUT
ARG BUILD_SCRIPT
ARG POST_BUILD_SCRIPT

# arguments potentially used by steps
ARG HOME
ARG NODE_ENV
ARG RACK_ENV
ARG RAILS_ENV
ARG RAILS_HOST_NAME
ARG SECRET_KEY_BASE
ARG TZ

# Set build shell
SHELL ["/bin/bash", "-c"]

# Use root user
USER root

# OLD:
# # Get proper node version via nodesource
# RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

RUN bash -vxc "${PRE_INSTALL_SCRIPT:-"echo 'no PRE_INSTALL_SCRIPT provided'"}"

# Install dependencies
RUN    export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ${BUILD_PACKAGES}

# OLD:
# RUN apt-get install -y npm

RUN bash -vxc "${INSTALL_SCRIPT:-"echo 'no INSTALL_SCRIPT provided'"}"

# Install specific versions of dependencies
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# TODO: Load artifacts

# OLD:
# # set up app-src directory
# COPY . /app-src
# WORKDIR /app-src

# set up app-src directory
WORKDIR ${HOME}
COPY Gemfile Gemfile.lock ./

RUN bash -vxc "${PRE_BUILD_SCRIPT:-"echo 'no PRE_BUILD_SCRIPT provided'"}"

# install gems and build the app
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT} \
    && bundle package \
    && bundle install \
    && bundle clean \
    && bundle exec bootsnap precompile --gemfile

COPY . .

# These args might be used by the build script and have to be specified
# from outside of the build. They change with each build, so only define them
# here for optimal layer caching.
# Also see https://docs.docker.com/engine/reference/builder/#impact-on-build-caching
# ARG OPENSHIFT_BUILD_COMMIT
# ARG OPENSHIFT_BUILD_SOURCE
# ARG OPENSHIFT_BUILD_REFERENCE
# ARG BUILD_COMMIT="${OPENSHIFT_BUILD_COMMIT}"
# ARG BUILD_REPO="${OPENSHIFT_BUILD_SOURCE}"
# ARG BUILD_REF="${OPENSHIFT_BUILD_REFERENCE}"

RUN bash -vxc "${BUILD_SCRIPT:-"echo 'no BUILD_SCRIPT provided'"}"

RUN bash -vxc "${POST_BUILD_SCRIPT:-"echo 'no POST_BUILD_SCRIPT provided'"}"

RUN bundle exec bootsnap precompile app/ lib/

# TODO: Save artifacts

RUN rm -rf vendor/cache/ .git spec/ node_modules/


#################################
#           Run Stage           #
#################################

# This image will be replaced by Openshift
FROM ruby:${RUBY_VERSION}-slim AS app

# arguments for steps
ARG RUN_PACKAGES
ARG BUNDLER_VERSION
ARG BUNDLE_WITHOUT

# arguments potentially used by steps
ARG NODE_ENV
ARG RACK_ENV
ARG RAILS_ENV

# data persisted in the image
ARG PS1
ARG TZ

ENV HOME="${HOME}" \
    PATH="${HOME}/bin:${PATH}" \
    PS1="${PS1}" \
    TZ="${TZ}" \
    BUILD_REPO="${BUILD_REPO}" \
    BUILD_REF="${BUILD_REF}" \
    BUILD_COMMIT="${BUILD_COMMIT}" \
    NODE_ENV="${NODE_ENV}" \
    RAILS_ENV="${RAILS_ENV}" \
    RACK_ENV="${RACK_ENV}" \
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

# Set runtime shell
SHELL ["/bin/bash", "-c"]

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 --gecos "" app

# Install dependencies, remove apt!
RUN    export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y ${RUN_PACKAGES} vim curl less \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Copy deployment ready source code from build
COPY --from=build ${HOME} ${HOME}
WORKDIR ${HOME}

# Create pids folder for puma and
# set group permissions to folders that need write permissions.
# Beware that docker builds on OpenShift produce different permissions
# than local docker builds!
RUN    mkdir -p         ${HOME}/tmp/pids \
    && chgrp    0       ${HOME} \
    && chgrp -R 0       ${HOME}/tmp \
    && chgrp -R 0       ${HOME}/log \
    && chmod u+w,g=u    ${HOME} \
    && chmod -R u+w,g=u ${HOME}/tmp \
    && chmod -R u+w,g=u ${HOME}/log

# # Install specific versions of dependencies
# RUN gem install bundler:${BUNDLER_VERSION} --no-document

# Use cached gems
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT}

# These args contain build information. Also see build stage.
# They change with each build, so only define them here for optimal layer caching.
# Also see https://docs.docker.com/engine/reference/builder/#impact-on-build-caching
# Openshift specific
ARG BUILD_REPO
ARG BUILD_REF
ARG BUILD_COMMIT
ARG BUILD_DATE

ENV BUILD_REPO="${BUILD_REPO}" \
    BUILD_REF="${BUILD_REF}" \
    BUILD_COMMIT="${BUILD_COMMIT}" \
    BUILD_DATE="${BUILD_DATE}"

# Set runtime user (although OpenShift uses a custom user per project instead)
USER 1001

CMD ["bundle", "exec", "puma", "-t", "8"]

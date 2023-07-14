#################################
#          Variables            #
#################################

# Versioning
ARG RUBY_VERSION="3.2"

# Packages
ARG BUILD_PACKAGES="libpq-dev build-essential"
ARG RUN_PACKAGES="git imagemagick libpq5 libjemalloc-dev libjemalloc2"

# Scripts
ARG PRE_INSTALL_SCRIPT
ARG INSTALL_SCRIPT
ARG PRE_BUILD_SCRIPT
ARG BUILD_SCRIPT
ARG POST_BUILD_SCRIPT="echo \"(built at: $(date '+%Y-%m-%d %H:%M:%S'))\" > /${HOME}/BUILD_INFO"

# Bundler specific
ARG BUNDLE_WITHOUT_GROUPS="development:metrics:test"

# App specific
ARG RAILS_ENV="production"
ARG RACK_ENV="production"
ARG NODE_ENV="production"
ARG RAILS_HOST_NAME="unused.example.net"
ARG SECRET_KEY_BASE="needs-to-be-set"

# Runtime ENV vars
ARG HOME="/app-src"
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
ARG PRE_BUILD_SCRIPT
ARG BUNDLE_WITHOUT_GROUPS
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

RUN bash -vxc "${PRE_INSTALL_SCRIPT:-"echo 'no PRE_INSTALL_SCRIPT provided'"}"

# Install dependencies
RUN    export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends ${BUILD_PACKAGES}

RUN bash -vxc "${INSTALL_SCRIPT:-"echo 'no INSTALL_SCRIPT provided'"}"

# TODO: Load artifacts

# set up app-src directory
WORKDIR ${HOME}
COPY Gemfile Gemfile.lock ./

RUN bash -vxc "${PRE_BUILD_SCRIPT:-"echo 'no PRE_BUILD_SCRIPT provided'"}"

# install bundler, gems and build the app
RUN    gem install bundler \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT_GROUPS} \
    && bundle install \
    && bundle clean \
    && bundle exec bootsnap precompile --gemfile

COPY . .

RUN bash -vxc "${BUILD_SCRIPT:-"echo 'no BUILD_SCRIPT provided'"}"

RUN bash -vxc "${POST_BUILD_SCRIPT:-"echo 'no POST_BUILD_SCRIPT provided'"}"

RUN bundle exec bootsnap precompile app/ lib/

# TODO: Save artifacts

RUN rm -rf vendor/cache/ .git spec/ node_modules/

#################################
#     Frontend Build Stage      #
#################################

# Selected for the specific ember / node combination
FROM danlynn/ember-cli:3.28.2-node_14.18 AS frontend-build

WORKDIR /myapp
COPY --from=build /app-src/frontend /myapp
RUN yarn install --frozen-lockfile --no-progress && yarn build-prod

#################################
#           Run Stage           #
#################################

# This image will be replaced by Openshift
FROM ruby:${RUBY_VERSION}-slim AS run

# arguments for steps
ARG RUN_PACKAGES
ARG BUNDLE_WITHOUT_GROUPS

# arguments potentially used by steps
ARG HOME
ARG NODE_ENV
ARG PS1
ARG RACK_ENV
ARG RAILS_ENV
ARG TZ

# data persisted in the image
ENV HOME="${HOME}" \
    PATH="${HOME}/bin:${PATH}" \
    PS1="${PS1}" \
    TZ="${TZ}" \
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
WORKDIR ${HOME}
COPY --from=build ${HOME} ${HOME}

# Copy from additional, app specific stages
COPY --from=frontend-build /myapp/dist/* ${HOME}/public

# Create pids folder for puma and
# set group permissions to folders that need write permissions.
# Beware that docker builds on OpenShift produce different permissions
# than local docker builds!
RUN    mkdir -p         ${HOME}/log \
    && mkdir -p         ${HOME}/tmp/pids \
    && chgrp    0       ${HOME} \
    && chgrp -R 0       ${HOME}/log \
    && chgrp -R 0       ${HOME}/tmp \
    && chmod u+w,g=u    ${HOME} \
    && chmod -R u+w,g=u ${HOME}/log \
    && chmod -R u+w,g=u ${HOME}/tmp

# Set runtime user (although OpenShift uses a custom user per project instead)
USER 1001

# Use cached gems
RUN    bundle config set --local deployment 'true' \
    && bundle config set --local without ${BUNDLE_WITHOUT_GROUPS}

# TODO: Move to docs
# These args contain build information. Also see build stage.
# They change with each build, so only define them here for optimal layer caching.
# Also see https://docs.docker.com/engine/reference/builder/#impact-on-build-caching
# Openshift specific / Cache busting
ARG BUILD_REPO
ARG BUILD_REF
ARG BUILD_COMMIT
ARG BUILD_DATE

ENV BUILD_REPO="${BUILD_REPO}" \
    BUILD_REF="${BUILD_REF}" \
    BUILD_COMMIT="${BUILD_COMMIT}" \
    BUILD_DATE="${BUILD_DATE}"

CMD ["bundle", "exec", "puma", "-t", "8"]

# __________      .__.__       .___   _________ __
# \______   \__ __|__|  |    __| _/  /   _____//  |______     ____   ____
#  |    |  _/  |  \  |  |   / __ |   \_____  \\   __\__  \   / ___\_/ __ \
#  |    |   \  |  /  |  |__/ /_/ |   /        \|  |  / __ \_/ /_/  >  ___/
#  |______  /____/|__|____/\____ |  /_______  /|__| (____  /\___  / \___  >
#         \/                    \/          \/           \//_____/      \/

FROM ruby:2.7 AS build

# Set environment (better in the openshift configmanagement?)
# ENV RAILS_ENV=production RACK_ENV=production SECRET_KEY_BASE=cannot-be-blank-for-production-env-when-building

# Use root user
USER root

# Install dependencies, remove apt!
# ${ADDITIONAL_BUILD_PACKAGES}?
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libpq-dev \
    nodejs npm \
    && npm install -g npm

# Install specific yarn version, env forces cache miss?
ENV YARN_VERSION=1.22.10
RUN npm install yarn -g && yarn set version ${YARN_VERSION}

# Install specific bundler version
ENV BUNDLER_VERSION=2.2.16
RUN gem install bundler:${BUNDLER_VERSION} --no-document

# Load artifacts

# set up app-src directory
COPY . /app-src
WORKDIR /app-src

# Run deployment
RUN yarn install && \
    bundle config set --local deployment 'true' && \
    bundle package && \
    bundle install

# Save artifacts

# __________                 _________ __
# \______   \__ __  ____    /   _____//  |______     ____   ____
#  |       _/  |  \/    \   \_____  \\   __\__  \   / ___\_/ __ \
#  |    |   \  |  /   |  \  /        \|  |  / __ \_/ /_/  >  ___/
#  |____|_  /____/|___|  / /_______  /|__| (____  /\___  / \___  >
#         \/           \/          \/           \//_____/      \/

# Dieses image wird von Openshift ersetzt
FROM ruby:2.7-slim AS app

# Add user
RUN adduser --disabled-password --uid 1001 --gid 0 app

# Install dependencies, remove apt!
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    imagemagick libpq5 \
    vim-tiny curl git \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Copy deployment ready source code
# Copy codebase from build
COPY --from=build /app-src /app-src
WORKDIR /app-src

RUN chgrp -R 0 /app-src && \
    chmod -R u+w,g=u /app-src

ENV HOME=/app-src

# Use cached gems
RUN bundle config set --local deployment 'true' && bundle

# Maybe delete vendor/cache? 20M

# make sure unique secret key is set by operator (better in configmanagement?)
# ENV SECRET_KEY_BASE=
# ENV RAILS_LOG_TO_STDOUT=1

USER 1001

ENTRYPOINT ["bundle", "exec", "puma", "-t", "8"]

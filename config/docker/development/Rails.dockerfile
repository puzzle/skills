FROM ruby:4.0.1

USER root

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /myapp

COPY ./rails-entrypoint /usr/local/bin

RUN useradd app -m -U -u 1000
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get update
RUN apt-get install -y direnv firefox-esr nodejs graphicsmagick
RUN npm install -g corepack && corepack enable

RUN mkdir /opt/bundle /seed
RUN chown -R app:app /myapp /opt/bundle /seed

USER app

ENTRYPOINT ["rails-entrypoint"]
CMD [ "rails", "server", "-b", "0.0.0.0"]

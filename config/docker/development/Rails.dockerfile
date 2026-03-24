FROM ruby:4.0.1

USER root

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV COREPACK_HOME=/home/app/.corepack

WORKDIR /myapp

RUN useradd app -m -U -u 1000

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -

RUN apt-get update && apt-get install -y direnv firefox-esr nodejs graphicsmagick sudo

RUN npm install -g corepack && corepack enable

RUN mkdir -p /opt/bundle /seed /myapp && \
    chown -R app:app /opt/bundle /seed /myapp

COPY ./rails-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/rails-entrypoint

ENTRYPOINT ["rails-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]
FROM ruby:4.0.1

USER root

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -

RUN apt-get update && apt-get install -y direnv firefox-esr nodejs graphicsmagick sudo

RUN useradd app -m -U -u 1000 && \
    echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /opt/bundle /seed /myapp && \
    chown -R app:app /opt/bundle /seed /myapp

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
ENV COREPACK_HOME=/home/app/.corepack

WORKDIR /myapp

RUN mkdir -p /home/app/.corepack && chown -R app:app /home/app
RUN npm install -g corepack && corepack enable

COPY ./rails-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/rails-entrypoint

ENTRYPOINT ["rails-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]
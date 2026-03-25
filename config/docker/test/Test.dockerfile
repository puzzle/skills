FROM ruby:4.0.1

ENV RAILS_ENV=test
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN useradd app -m -U -u 1000

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get update
RUN apt-get install direnv -y
RUN apt-get install firefox-esr -y
RUN apt-get install -y nodejs
RUN apt-get install -y graphicsmagick
RUN npm install -g corepack && corepack enable

RUN mkdir /opt/bundle && chmod 777 /opt/bundle
RUN mkdir /seed && chmod 777 /seed

USER app

WORKDIR /myapp

COPY ./test-entrypoint /usr/local/bin

ENTRYPOINT ["test-entrypoint"]
CMD [ "rails", "server", "-b", "0.0.0.0"]

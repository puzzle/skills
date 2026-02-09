FROM ruby:4.0.1

USER root

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

WORKDIR /myapp

COPY ./rails-entrypoint /usr/local/bin

RUN useradd app -m -U -d /myapp/
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get update
RUN apt-get install direnv -y
RUN apt-get install firefox-esr -y
RUN apt-get install -y nodejs
RUN apt-get install -y graphicsmagick
RUN npm install -g corepack && corepack enable

RUN mkdir /opt/bundle && chmod 777 /opt/bundle
RUN mkdir /seed && chmod 777 /seed
RUN mkdir /home/developer && chmod 777 /home/developer
ENV HOME=/home/developer

ENTRYPOINT ["rails-entrypoint"]
CMD [ "rails", "server", "-b", "0.0.0.0"]

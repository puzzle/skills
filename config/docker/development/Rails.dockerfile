FROM ruby:4.0.1

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
#ENV COREPACK_HOME=/home/app/.corepack

RUN useradd app -m -U -u 1000

run whoami

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
RUN apt-get update
RUN apt-get install direnv -y
RUN apt-get install firefox-esr -y
RUN apt-get install -y nodejs
RUN apt-get install -y graphicsmagick
RUN npm install -g corepack && corepack enable

RUN mkdir /opt/bundle && chmod 777 /opt/bundle
# RUN chown -R app:app /myapp
RUN mkdir /seed && chmod 777 /seed

user app

WORKDIR /myapp
COPY ./rails-entrypoint /usr/local/bin/

#RUN mkdir /home/test && chmod 777 /home/test

#USER app
#RUN whoami

ENTRYPOINT ["rails-entrypoint"]
CMD ["rails", "server", "-b", "0.0.0.0"]
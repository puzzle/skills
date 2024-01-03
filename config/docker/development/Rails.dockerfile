FROM ruby:3.2

USER root

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/opt/bundle

WORKDIR /myapp

COPY ./rails-entrypoint /usr/local/bin

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update
RUN apt-get install direnv -y
RUN apt-get install firefox-esr -y
RUN apt-get install nodejs -y
RUN apt-get install npm -y
RUN npm install -g yarn

RUN mkdir /opt/bundle && chmod 777 /opt/bundle
RUN mkdir /seed && chmod 777 /seed
RUN mkdir /home/developer && chmod 777 /home/developer
ENV HOME=/home/developer

ENTRYPOINT ["rails-entrypoint"]
CMD [ "rails", "server", "-b", "0.0.0.0"]

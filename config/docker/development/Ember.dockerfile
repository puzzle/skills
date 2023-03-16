FROM danlynn/ember-cli:3.28.2-node_14.18

RUN chown 1000:1000 /myapp

COPY ember-entrypoint /usr/local/bin

USER 1000

RUN yarn install
ENTRYPOINT ["ember-entrypoint"]
CMD ember serve --proxy=http://rails:3000
import { module } from 'qunit';
import Ember from 'ember';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';

const { RSVP: { resolve, all } } = Ember;

export default function(name, options = {}) {
  module(name, {
    beforeEach() {
      this.application = startApp();

      let beforeEach = options.beforeEach && options.beforeEach.apply(this, arguments);
      return resolve(beforeEach)
        .then(() =>
          fetch('/api/test_api', { method: 'POST' })
        );
    },

    afterEach() {
      let afterEach = options.afterEach && options.afterEach.apply(this, arguments);
      return resolve(afterEach)
        .finally(() =>
          all([
            destroyApp(this.application),
            fetch('/api/test_api', { method: 'DELETE' })
          ])
        );
    }
  });
}

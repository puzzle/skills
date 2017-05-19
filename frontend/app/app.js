import Ember from 'ember';
import RSVP from 'rsvp';
import Resolver from './resolver';
import loadInitializers from 'ember-load-initializers';
import config from './config/environment';

window.Promise = RSVP.Promise;

const App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;

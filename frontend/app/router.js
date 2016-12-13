import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function(){
  this.route('people');
  this.resource('person', { path: 'people/:person_id' });
});

export default Router;

import DS from 'ember-data';
import Ember from 'ember';

const { String: { pluralize, underscore } } = Ember;

export default DS.JSONAPIAdapter.extend({
  pathForType(type) {
    return "api/" + pluralize(underscore(type));
  }
});

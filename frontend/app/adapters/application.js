import DS from 'ember-data';
import Ember from 'ember';

const { String: { pluralize, underscore } } = Ember;

export default DS.JSONAPIAdapter.extend({
  namespace: 'api',

  pathForType(type) {
    return pluralize(underscore(type));
  }
});

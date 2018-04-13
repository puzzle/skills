// app/transforms/array.js
import Ember from 'ember';
import DS from 'ember-data';

export default DS.Transform.extend({
  deserialize: function(serialized) {
    if (Ember.isArray(serialized)) {
      return Ember.A(serialized);
    } else {
      return Ember.A();
    }
  },

  serialize: function(deserialized) {
    if (Ember.isArray(deserialized)) {
      return Ember.A(deserialized);
    } else {
      return Ember.A();
    }
  }
});

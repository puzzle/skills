import Ember from 'ember';
import PersonModel from '../../models/person';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord('person');
  }
});

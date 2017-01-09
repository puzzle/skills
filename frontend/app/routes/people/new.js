import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord('person');
  },

  actions: {
    createPerson(person) {
      this.send('reloadPeopleList');
      this.transitionTo('person', person);
    }
  }
});

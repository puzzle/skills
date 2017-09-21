import Route from '@ember/routing/route';

export default Route.extend({
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

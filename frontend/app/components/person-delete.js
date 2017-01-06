import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      this.get('router').transitionTo('people');
    }
  }

});

import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      if(personToDelete.get('variationName')){
        this.get('router').transitionTo('person', personToDelete.get('originPersonId'));
      }else{
        this.get('router').transitionTo('people');
      }
    }
  }

});

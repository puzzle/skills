import Ember from 'ember';

export default Ember.Component.extend({
  ajax: Ember.inject.service(),
  router: Ember.inject.service(),
  
  actions: {
    loadPersonVariations(originPersonId, id = originPersonId) {
      id = originPersonId || id
      return this.get('ajax')
       .request(`people/${id}/variations`)
        .then(response => response.data)
        .then(personVariations => this.set('personVariations', personVariations));
    },

    createPersonVariation(id, changeset){
      return this.get('ajax')
       .request(`people/${id}/variation`, {
         method: 'POST',
         data: {
          variation_name: changeset.get('variationName')
         }
        })
        .then(response => response.data)
        .then(personVariation => this.get('router').transitionTo('person', personVariation.id));
    },

    updateVariationName(changeset){
      return changeset.save();
    },

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

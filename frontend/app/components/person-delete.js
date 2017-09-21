import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  router: service(),

  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      if (personToDelete.get('variationName')) {
        this.get('router').transitionTo('person', personToDelete.get('originPersonId'));
      } else {
        this.get('router').transitionTo('people');
      }
    }
  }

});

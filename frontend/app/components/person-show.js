import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),

  init() {
    this._super(...arguments);
  },

  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      this.get('router').transitionTo('people');
    },

    exportCvOdt(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}.odt`;
      this.get('download').file(url)
    },
  }
});

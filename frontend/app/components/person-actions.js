import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),

  actions: {
    exportCvOdt(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}.odt`;
      this.get('download').file(url)
    },

    exportDevFws(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}/fws.odt?discipline=development`;
      this.get('download').file(url)
    },

    exportSysFws(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}/fws.odt?discipline=system_engineering`;
      this.get('download').file(url)
    },

    deletePerson(personToDelete) {
      personToDelete.destroyRecord().then(() => {
        this.toggleProperty('deletePersonConfirm');
        this.get('router').transitionTo('people')
          .then(() => this.sendAction('onDelete'))
          .then(() => this.get('notify').success('Person gelöscht!'));
      });
    }
  }
});

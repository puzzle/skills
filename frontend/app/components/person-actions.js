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

    loadPersonVariations(originPersonId, id = originPersonId) {
      id = originPersonId || id;
      return this.get('ajax')
        .request(`people/${id}/variations`)
        .then(response => response.data)
        .then(personVariations => this.set('personVariations', personVariations));
    },

    createPersonVariation(id, changeset) {
      return this.get('ajax')
        .request(`people/${id}/variation`, {
          method: 'POST',
          data: {
            variation_name: changeset.get('variationName')
          }
        })
        .then(response => response.data)
        .then(personVariation => this.get('router').transitionTo('person', personVariation.id))
        .then(
          value => this.get('notify').success('Variante erstellt!'),
          reason => this.get('notify').alert(reason.payload, { closeAfter: 15000 })
        );
    },

    updateVariationName(changeset) {
      return changeset.save();
    },

    deletePerson(personToDelete) {
      personToDelete.destroyRecord().then(() => {
        this.toggleProperty('deletePersonConfirm');
        if (personToDelete.get('variationName')) {
          this.get('router').transitionTo('person', personToDelete.get('originPersonId'))
            .then(() => this.get('notify').success('Variante entfernt!'));

        }
        else {
          this.get('router').transitionTo('people')
            .then(() => this.sendAction('onDelete'))
            .then(() => this.get('notify').success('Person gelöscht!'));
        }
      });
    }
  }
});

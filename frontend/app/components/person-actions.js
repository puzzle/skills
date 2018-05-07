import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),

  actions: {
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

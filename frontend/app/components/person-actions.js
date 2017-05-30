import Ember from 'ember';
import ENV from '../config/environment';

export default Ember.Component.extend({
  ajax: Ember.inject.service(),
  router: Ember.inject.service(),
  session: Ember.inject.service('session'),

  actions: {
    exportCvOdt(personId, e) {
      e.preventDefault();

      let url = `${ENV.APP.documentExportHost}/api/people/${personId}.odt`;

      let xhr = new XMLHttpRequest;
      xhr.responseType = 'blob';
      xhr.onload = () => {
        let [ , fileName ] = /filename="(.*?)"/.exec(xhr.getResponseHeader('Content-Disposition'));
        let file = new File([ xhr.response ], fileName);
        window.location = URL.createObjectURL(file);
      };
      xhr.open('GET', url);
      xhr.setRequestHeader('api-token', this.get('session.data.authenticated.token'));
      xhr.setRequestHeader('ldap-uid', this.get('session.data.authenticated.ldap_uid'));
      xhr.send();
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
            function(value) { this.get('notify').success('Variante erstellt!') }.bind(this),
            function(reason) { this.get('notify').alert(reason.payload, { closeAfter: 15000 } ) }.bind(this)
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

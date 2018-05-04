import Component from '@ember/component';
import { A } from '@ember/array';
import { isBlank } from '@ember/utils';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import $ from 'jquery';

export default Component.extend({
  store: service(),
  i18n: service(),
  options: A(['Scrum', 'CI/CD', 'Hermes', 'BA', 'Java EE', 'Java SE', 'PHP',
    'Docker', 'OpenShift', 'Ember', 'Angular', 'Git']),
  selected: A([]),

  init() {
    this._super(...arguments);
  },

  actions: {
    /*submit(changeset, company) {
      changeset.set('company', company);
      return changeset.save()
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Angebot wurde aktualisiert!'))
        .catch(() => {
          let offer = this.get('offer');
          this.get('notify').alert(offer);

          let errors = offer.get('errors').slice(); // clone array as rollbackAttributes mutates

          offer.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`offer.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },*/

    submit(company) {
      company.save()
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Yaii'))
        .then (() => 
          Promise.all([
            ...company
               .get('offers')
               .filterBy('hasDirtyAttributes')
               .map(offer => offer.save())
            ])
        )
        .catch(() => {
          let offer = this.get('offer');
          this.get('notify').alert(offer);

          let errors = offer.get('errors').slice(); // clone array as rollbackAttributes mutates

          offer.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`offer.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    createNewOffer(company) {
      this.get('store').createRecord('offer', { company });
    },

    deleteOffer(offerToDelete) {
      //remove overlay from delete confirmation
      $('.modal-backdrop').remove();
      offerToDelete.destroyRecord();
    },

    createOnEnter(select, e, offer) {
      if (e.keyCode === 13 && select.isOpen &&
        !select.highlighted && !isBlank(select.searchText)) {

        let selected = this.get('selected');
        if (!selected.includes(select.searchText)) {
          this.get('options').pushObject(select.searchText);
          select.actions.choose(select.searchText);
        }
      }
    }
  }
});

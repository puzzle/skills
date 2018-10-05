import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';

export default Component.extend({
  store: service(),
  i18n: service(),

  init() {
    this._super(...arguments);
    this.martialStatuses = (['ledig', 'verheiratet', 'verwittwet', 'eingetragene Partnerschaft', 'geschieden']);
    this.roles = (['Software-Entwickler', 'Software-Ingenieur', 'User Experience Consultant', 'Grafik Designer',
      'Requirements Engineer', 'System-Techniker', 'System-Ingenieur', 'Architekt', 'Solutions Architect',
      'Projektleiter (M1)', 'Bereichsleiter (M2)', 'Bereichsleiter GL (M3)', 'Kaufmann / Kauffrau', 'Controller',
      'Marketing- und Kommunikationsfachmann / -fachfrau', 'Verkäufer', 'Key Account Manager']);
  },

  companiesToSelect: computed(function() {
    return this.get('store').findAll('company');
  }),


  personPictureUploadPath: computed('person.id', function() {
    return `/people/${this.get('person.id')}/picture`;
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  actions: {
    submit(changeset) {
      return changeset.save()
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Personalien wurden aktualisiert!'))
        .catch(() => {
          let person = this.get('person');
          let errors = person.get('errors').slice(); // clone array as rollbackAttributes mutates

          person.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`person.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    }
  }

});

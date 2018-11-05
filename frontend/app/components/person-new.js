import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import { getNames } from 'ember-i18n-iso-countries';

export default Component.extend({
  i18n: service(),
  store: service(),

  init() {
    this._super(...arguments);
    this.martialStatuses = ['ledig', 'verheiratet', 'verwittwet', 'eingetragene Partnerschaft', 'geschieden'];
    this.roles = (['Software-Entwickler', 'Software-Ingenieur', 'User Experience Consultant', 'Grafik Designer',
      'Requirements Engineer', 'System-Techniker', 'System-Ingenieur', 'Architekt', 'Solutions Architect',
      'Projektleiter (M1)', 'Bereichsleiter (M2)', 'Bereichsleiter GL (M3)', 'Kaufmann / Kauffrau', 'Controller',
      'Marketing- und Kommunikationsfachmann / -fachfrau', 'Verkäufer', 'Key Account Manager']);
    let countriesArray = Object.entries(getNames("de"))
    this.set('countries', countriesArray);
    let origin = this.get('person.origin');
    this.selectedCountry = countriesArray.find(function(country) {
      return country[1] == origin
    });
  },

  sortedRoles: computed(function() {
    return this.get('roles').sort()
  }),

  companiesToSelect: computed(function() {
    return this.get('store').findAll('company');
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  actions: {
    submit(newPerson) {
      return newPerson.save()
        .then(() => this.sendAction('submit', newPerson))
        .then(() => this.get('notify').success('Person wurde erstellt!'))
        .then(() => this.get('notify').success('Füge nun ein Profilbild hinzu!'))
        .catch(() => {
          this.get('newPerson.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`person.${attribute}`)['string']
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
    },

    setBirthdate(selectedDate) {
      this.set('newPerson.birthdate', selectedDate[0]);
    },

    setOrigin(selectedCountry) {
      this.set('newPerson.origin', selectedCountry[1]);
      this.set('selectedCountry', selectedCountry)
    },
  }
});

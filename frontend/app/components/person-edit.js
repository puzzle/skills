import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import { getNames } from 'ember-i18n-iso-countries';


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

  getCountryByName(name) {
    return this.countries.find(function(country) {
      if (country.name == name) {
        return country;
      }
    });
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
    },

    setBirthdate(selectedDate) {
      this.set('person.birthdate', selectedDate[0]);
    },

    setOrigin(selectedCountry) {
      this.set('person.origin', selectedCountry[1]);
      this.set('selectedCountry', selectedCountry);
    },

  }

});

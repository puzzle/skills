import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import { getNames as countryNames } from 'ember-i18n-iso-countries';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';


export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),

  init() {
    this._super(...arguments);
    this.martialStatuses = (['ledig', 'verheiratet', 'verwittwet', 'eingetragene Partnerschaft', 'geschieden']);
    this.initNationalities();
    this.initCheckbox();
  },

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  aFunction: on(keyUp('Escape'), function() {
    this.personEditing();
  }),

  initCheckbox() {
    if (this.get('person.nationality2')) {
      this.set('secondNationality', true)
    } else {
      this.set('secondNationality', false)
    }
  },

  initNationalities() {
    const countriesArray = Object.entries(countryNames("de"))
    this.set('countries', countriesArray);
    const nationality = this.get('person.nationality');
    const nationality2 = this.get('person.nationality2');
    this.selectedNationality = this.getCountry(nationality);
    this.selectedNationality2 = this.getCountry(nationality2);
  },

  getCountry(code) {
    return this.countries.find(function(country) {
      return country[0] === code;
    });
  },

  sortedRoles: computed(function() {
    return this.get('store').findAll('role')
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

    switchNationality(value) {
      if (value == false) {
        this.set('person.nationality2', undefined);
      }
    },

    setBirthdate(selectedDate) {
      this.set('person.birthdate', selectedDate[0]);
    },

    setNationality(selectedCountry) {
      this.set('person.nationality', selectedCountry[0]);
      this.set('selectedNationality', selectedCountry);
    },

    setNationality2(selectedCountry) {
      if (selectedCountry) {
        this.set('person.nationality2', selectedCountry[0]);
      } else {
        // nationality2 can be blank / cleared
        this.set('person.nationality2', undefined);
      }
      this.set('selectedNationality2', selectedCountry);
    },

    setRole(selectedRole) {
      this.set('person.roles', [selectedRole]);
    },

  }

});

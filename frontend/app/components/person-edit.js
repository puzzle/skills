import { inject as service } from '@ember/service';
import ApplicationComponent from './application-component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import { getNames as countryNames } from 'ember-i18n-iso-countries';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';
import Person from '../models/person';

export default ApplicationComponent.extend(EKMixin, {
  store: service(),
  intl: service(),

  init() {
    this._super(...arguments);
    this.initMaritalStatuses();
    this.initNationalities();
    this.initCheckbox();
    this.callBackRole = this.get('person.roles.firstObject');
    this.callBackCompany = this.get('person.company');
  },

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  aFunction: on(keyUp('Escape'), function() {
    this.send('abortEdit');
  }),

  initCheckbox() {
    if (this.get('person.nationality2')) {
      this.set('secondNationality', true)
    } else {
      this.set('secondNationality', false)
    }
  },

  initMaritalStatuses() {
    this.maritalStatusesHash = Person.MARITAL_STATUSES
    this.maritalStatuses = Object.values(this.maritalStatusesHash)
    const maritalStatusKey = this.get('person.maritalStatus')
    this.selectedMaritalStatus = this.maritalStatusesHash[maritalStatusKey]
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
        .then (() =>
          Promise.all([
            ...changeset
              .get('languageSkills')
              .map(languageSkill => languageSkill.save())
          ])
        )
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Personalien wurden aktualisiert!'))
        .catch(() => {
          let person = this.get('person');
          let languageSkills = this.get('person.languageSkills');
          let errors = person.get('errors').slice(); // clone array as rollbackAttributes mutates

          languageSkills.forEach(skill => {
            errors = errors.concat(skill.get('errors').slice())
          });

          person.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('intl').t(`person.${attribute}`)
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    abortEdit() {
      const person = this.get('person')
      if (person.get('hasDirtyAttributes')) {
        person.rollbackAttributes();
      }
      let languageSkills = this.get('person.languageSkills').toArray();
      languageSkills.forEach(skill => {
        if (skill.get('isNew')) {
          skill.destroyRecord();
        }
        if (skill.get('hasDirtyAttributes')) {
          skill.rollbackAttributes();
        }
      });
      this.set('person.company', this.get('callBackCompany'))
      this.set('person.roles', [this.get('callBackRole')])


      this.sendAction('personEditing');
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

    setCompany(company) {
      this.set('person.company', company)
    },

    setRole(selectedRole) {
      this.set('person.roles', [selectedRole]);
    },

    setMaritalStatus(selectedMaritalStatus) {
      const obj = this.maritalStatusesHash
      const key = Object.keys(obj).find(key => obj[key] === selectedMaritalStatus);
      this.set('person.maritalStatus', key);
      this.set('selectedMaritalStatus', selectedMaritalStatus);
    },

  }

});

import { inject as service } from '@ember/service';
import ApplicationComponent from './application-component';
import { computed, observer } from '@ember/object';
import { isBlank } from '@ember/utils';
import { getNames as countryNames } from 'ember-i18n-iso-countries';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';
import Person from '../models/person';

export default ApplicationComponent.extend(EKMixin, {
  store: service(),
  i18n: service(),
  session: service('keycloak-session'),

  init() {
    this._super(...arguments);
    this.initMaritalStatuses();
    this.initNationalities();
    this.initCheckbox();
    this.set('departments', Person.DEPARTMENTS);
    this.set('roleLevels', Person.ROLE_LEVELS);
    this.callBackCompany = this.get('person.company');
    this.callBackRoleIds = {}
    this.get('person.peopleRoles').forEach(peopleRole =>
      this.callBackRoleIds[peopleRole.get('id')] =  peopleRole.get('role.id')
    );
  },

  picturePath: computed('person.picturePath', function(){
    if (this.get('person.picturePath')) {
      let path = this.get('person.picturePath') + "&authorizationToken=" + this.get('session.token')
      return path
    }
  }),

  personChanged: observer('person', function() {
    this.send('abortEdit');
    this.set('alreadyAborted', true)
  }),

  willDestroyElement() {
    this._super(...arguments);
    if (!this.get('alreadyAborted')) this.send('abortEdit');
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
    this.set('maritalStatuses', Object.values(this.maritalStatusesHash))
    const maritalStatusKey = this.get('person.maritalStatus')
    this.set('selectedMaritalStatus', this.maritalStatusesHash[maritalStatusKey])
  },

  initNationalities() {
    const countriesArray = Object.entries(countryNames("de"))
    this.set('countries', countriesArray);
    const nationality = this.get('person.nationality');
    const nationality2 = this.get('person.nationality2');
    this.set('selectedNationality', this.getCountry(nationality));
    this.set('selectedNationality2', this.getCountry(nationality2));
  },

  getCountry(code) {
    return this.countries.find(function(country) {
      return country[0] === code;
    });
  },

  sortedRoles: computed('sortedRoles', function() {
    const roles = this.get('store').findAll('role');
    roles.then(() => {
      const usedRoleNames = this.get('person.peopleRoles')
        .map(x => x.get('role.name'));

      roles.forEach(role => {
        if (usedRoleNames.includes(role.get('name'))) {
          role.set('disabled', true);
        } else {
          role.set('disabled', undefined);
        }
      }, this);
      this.set('sortedRoles', roles);
    });
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
        .then(() =>
          Promise.all([
            ...changeset
              .get('languageSkills')
              .map(languageSkill => languageSkill.get('hasDirtyAttributes') ? languageSkill.save() : null),
            ...changeset
              .get('peopleRoles')
              .map(peopleRole =>
                peopleRole.get('hasDirtyAttributes') ||
                peopleRole.get('role.id') != this.callBackRoleIds[peopleRole.get('id')] ? peopleRole.save() : null)
          ])
        )
        .then (() => this.set('alreadyAborted', true))
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Personalien wurden aktualisiert!'))
        .catch(() => {
          let person = this.get('person');
          let errors = person.get('errors').slice(); // clone array as rollbackAttributes mutates

          person.get('languageSkills').forEach(skill => {
            errors = errors.concat(skill.get('errors').slice())
          });

          person.get('peopleRoles').forEach(peopleRole => {
            let prErrors = peopleRole.get('errors').slice();
            const roleIdError = prErrors.findBy('attribute', 'role_id');
            prErrors.removeObject(roleIdError);
            errors = errors.concat(prErrors)
          });

          if (person.get('peopleRoles.length') === 0) {
            errors = errors.concat([{ attribute: 'person', message: 'muss eine Funktion haben' }])
          }

          person.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`person.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 8000 });
          });
        });
    },

    abortEdit() {
      const person = this.get('person')
      if (person.get('hasDirtyAttributes')) {
        person.rollbackAttributes();
      }

      this.set('person.company', this.get('callBackCompany'))

      let languageSkills = this.get('person.languageSkills').toArray();
      languageSkills.forEach(skill => {
        if (skill.get('isNew')) {
          skill.destroyRecord();
        }
        if (skill.get('hasDirtyAttributes')) {
          skill.rollbackAttributes();
        }
      });

      this.get('person.peopleRoles').forEach(peopleRole => {
        if (peopleRole.get('isNew')) {
          peopleRole.destroyRecord();
        }
        if (peopleRole.get('hasDirtyAttributes')) {
          peopleRole.rollbackAttributes();
        }
      });

      this.get('person.peopleRoles').forEach(peopleRole => {
        let oldRoleId = this.get('callBackRoleIds.' + peopleRole.get('id'))
        let role = this.get('store').peekRecord('role', oldRoleId)
        peopleRole.set('role', role)
      });

      this.set('alreadyAborted', true);
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
      this.set('person.birthdate', selectedDate);
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

    setDepartment(department) {
      this.set('person.department', department)
    },

    setCompany(company) {
      this.set('person.company', company)
    },

    setRole(peopleRole, selectedRole) {
      peopleRole.set('role', selectedRole);
    },

    setRoleWithTab(peopleRole, select, e) {
      if (e.keyCode == 9 && select.isOpen) {
        peopleRole.set('role', select.highlighted);
      }
    },

    setRoleLevel(peopleRole, level) {
      peopleRole.set('level', level);
    },

    setRoleLevelWithTab(peopleRole, select, e) {
      if (e.keyCode == 9 && select.isOpen) {
        peopleRole.set('level', select.highlighted);
      }
    },

    setRolePercent(peopleRole, event) {
      peopleRole.set('percent', event.target.value);
    },

    setMaritalStatus(selectedMaritalStatus) {
      const obj = this.maritalStatusesHash
      const key = Object.keys(obj).find(key => obj[key] === selectedMaritalStatus);
      this.set('person.maritalStatus', key);
      this.set('selectedMaritalStatus', selectedMaritalStatus);
    },

    addRole(person) {
      this.get('store').createRecord('people-role', { person });
    },

  }
});

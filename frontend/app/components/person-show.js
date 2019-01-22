import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import sortByLanguage from '../utils/sort-by-language';
import Person from '../models/person';

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),

  init() {
    this._super(...arguments);
  },

  sortedLanguageSkills: sortByLanguage('person.languageSkills'),

  maritalStatus: computed('person.maritalStatus', function() {
    const maritalStatuses = Person.MARITAL_STATUSES
    const key = this.get('person.maritalStatus')
    return maritalStatuses[key]
  }),

  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      this.get('router').transitionTo('people');
    },

    exportCvOdt(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}.odt`;
      this.get('download').file(url)
    }
  }
});

import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import sortByLanguage from '../utils/sort-by-language';
import Person from '../models/person';

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),
  session: service('keycloak-session'),

  picturePath: computed('person.picturePath', function(){
    if (this.get('person.picturePath')) {
      let path = this.get('person.picturePath') + "&authorizationToken=" + this.get('session.token')
      return path
    }
  }),

  sortedLanguageSkills: sortByLanguage('person.languageSkills'),

  maritalStatus: computed('person.maritalStatus', function() {
    const maritalStatuses = Person.MARITAL_STATUSES
    const key = this.get('person.maritalStatus')
    return maritalStatuses[key]
  }),

  actions: {
    exportCvOdt(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}.odt`;
      this.get('download').file(url)
    }
  }
});

import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  competenceList: computed('person.competences', function() {
    let competences = this.get('person.competences')
    if (competences == null) return '';
    return competences
      .split('\n')
  }),

  removeEmptyStrings(array) {
    for (let i = array.length; i--;) {
      if (array[i] == '') array.splice(i, 1);
    }
    return array;
  }
});

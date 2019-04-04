import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  competenceNotesList: computed('person.competenceNotes', function() {
    let competences = this.get('person.competenceNotes')
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

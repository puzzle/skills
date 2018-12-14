import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  competenceList: computed('person.competences', function() {
    let competences = this.get('person.competences')
    if (competences == null) return '';
    return competences
      .split('\n')
      .map(c => c.trim())
      .filter(c => c !== '');
  }),

  amountOfCompetences: computed('person.competences', function() {
    const competences = this.get('person.competences');
    if (competences == null) return 0;
    const validCompetences =
      this.removeEmptyStrings(competences.split(/\r\n|\r|\n/));
    return validCompetences.length;
  }),

  removeEmptyStrings(array) {
    for (let i = array.length; i--;) {
      if (array[i] == '') array.splice(i, 1);
    }
    return array;
  }
});

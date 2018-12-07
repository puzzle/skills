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

  amountOfCompetences: computed(function() {
    let competences = this.get('person.competences');
    if (competences == null) return 0;
    return competences.split(/\r\n|\r|\n/).length;
  })
});

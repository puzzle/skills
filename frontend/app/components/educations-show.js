import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  amountOfEducations: computed('sortedEducations', function() {
    return this.get('sortedEducations.length')
  }),

  sortedEducations: sortByYear('educations'),

  actions: {
    toggleEducationNew(triggerNew) {
      this.set('educationNew', triggerNew)
      this.set('sortedEducations', triggerNew ? sortByYear('educations').volatile() : sortByYear('educations'))
      this.notifyPropertyChange('amountOfEducations');
    }
  }
});

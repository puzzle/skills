import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';

export default Component.extend({
  amountOfAdvancedTrainings: computed('sortedAdvancedTrainings', function() {
    return this.get('sortedAdvancedTrainings.length');
  }),

  sortedAdvancedTrainings: sortByYear('advanced-trainings'),

  actions: {
    toggleAdvancedTrainingNew(triggerNew) {
      this.set('advanced-trainingNew', triggerNew)
      const sortedTrainings = sortByYear('advanced-trainings')
      this.set('sortedAdvancedTrainings', triggerNew ? sortedTrainings.volatile() : sortedTrainings)
      this.notifyPropertyChange('amountOfAdvancedTrainings');
    }
  }
});

import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';

export default Component.extend({
  amountOfActivities: computed('sortedActivities', function() {
    return this.get('sortedActivities.length');
  }),

  sortedActivities: sortByYear('activities'),

  actions: {
    toggleActivityNew(triggerNew) {
      this.set('activityNew', triggerNew)
      this.set('sortedActivities', triggerNew ? sortByYear('activities').volatile() : sortByYear('activities'))
      this.notifyPropertyChange('amountOfActivities');
    }
  }
});

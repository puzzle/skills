import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';

export default Component.extend({
  filtered: computed('activities.@each', function() {
    return this.get('activities');
  }),

  amountOfActivities: computed('activities.@each', function() {
    return this.get('activities.length');
  }),

  filteredActivities: sortByYear('filtered')
});

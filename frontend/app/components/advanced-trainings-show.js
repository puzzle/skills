import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';

export default Component.extend({
  /* exclude where id like null */
  filteredAdvancedTrainings: computed('@each.id', function() {
    return this.get('sortedAdvancedTrainings').filterBy('id');
  }),

  sortedAdvancedTrainings: sortByYear('advanced-trainings')
});

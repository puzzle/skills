import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';

export default Component.extend({
  /* exclude where id like null */
  filteredAdvancedTrainings: function() {
    return this.get('sortedAdvancedTrainings').filterBy('id');
  }.property('@each.id'),

  sortedAdvancedTrainings: sortByYear('advanced-trainings')
});

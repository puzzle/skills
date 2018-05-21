import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';

export default Component.extend({
  filtered: function() {
    return this.get('advanced-trainings').filterBy('id');
  }.property('advanced-trainings.@each'),

  filteredAdvancedTrainings: sortByYear('filtered'),
});

import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';


export default Component.extend({
  /* exclude where id like null */
  filteredActivities: function() {
    return this.get('sortedActivities').filterBy('id');
  }.property('@each.id'),

  sortedActivities: sortByYear('activities')
});

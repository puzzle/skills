import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';


export default Component.extend({
  filtered: function() {
    return this.get('activities').filterBy('id');
  }.property('activities.@each'),

  filteredActivities: sortByYear('filtered'),
});

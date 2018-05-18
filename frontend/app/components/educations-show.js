import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';


export default Component.extend({
  /* exclude where id like null */
  filteredEducations: function() {
    return this.get('sortedEducations').filterBy('id');
  }.property('@each.id'),

  sortedEducations: sortByYear('educations')
});

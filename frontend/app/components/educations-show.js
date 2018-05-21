import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  /* exclude where id like null */
  filteredEducations: computed('@each.id', function() {
    return this.get('sortedEducations').filterBy('id');
  }),

  sortedEducations: sortByYear('educations')
});

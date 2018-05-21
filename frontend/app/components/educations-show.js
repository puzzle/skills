import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  filtered: computed('educations.@each', function() {
    return this.get('educations').filterBy('id');
  }),

  filteredEducations: sortByYear('filtered'),
});

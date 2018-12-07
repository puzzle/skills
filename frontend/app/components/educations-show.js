import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  filtered: computed('educations.@each', function() {
    return this.get('educations');
  }),

  amountOfEducations: computed(function() {
    return this.get('educations.length')
  }),

  filteredEducations: sortByYear('filtered'),
});

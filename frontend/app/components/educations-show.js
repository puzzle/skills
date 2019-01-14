import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  amountOfEducations: computed('educations.@each', function() {
    return this.get('educations.length')
  }),

  sortedEducations: sortByYear('educations'),
});

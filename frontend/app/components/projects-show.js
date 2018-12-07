import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  sortedProjects: sortByYear('projects'),

  amountOfProjects: computed(function() {
    return this.get('projects.length');
  })
});

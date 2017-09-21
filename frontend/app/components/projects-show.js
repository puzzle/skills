import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';


export default Component.extend({
  sortedProjects: sortByYear('projects')
});

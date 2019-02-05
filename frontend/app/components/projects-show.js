import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { computed, observer } from '@ember/object';


export default Component.extend({
  sortedProjects: sortByYear('projects'),

  amountOfProjects: computed('sortedProjects', function() {
    return this.get('sortedProjects.length');
  }),

  projectsChanged: observer('sortedProjects', function() {
    this.set('projectEditing', null)
  }),

  actions: {
    toggleProjectNew(triggerNew) {
      this.set('projectNew', triggerNew)
      this.set('sortedProjects', triggerNew ? sortByYear('projects').volatile() : sortByYear('projects'))
      this.notifyPropertyChange('amountOfProjects');
    }
  }
});

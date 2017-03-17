import Ember from 'ember';
import PersonModel from '../models/person';

const { computed } = Ember;

export default Ember.Component.extend({
  filterBy: 'all',
  
  filteredList: computed('people.[]', 'filterBy', function(){
    if (this.filterBy === 'all'){
      return this.people;
    }
    return this.people.filterBy('attributes.status_id', parseInt(this.filterBy));
  }),

  statusData:computed(function(){
    return Object.keys(PersonModel.STATUSES).map(id => {
      return { id, name: PersonModel.STATUSES[id] };
    });
  }),

  actions: {
    setFilter(value){
      this.set('filterBy', value);
    }
  }
});

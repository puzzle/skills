import Ember from 'ember';
import PersonModel from '../models/person';
import { task, timeout } from 'ember-concurrency';

const { computed } = Ember;
const SEARCH_TIMEOUT = 250;

export default Ember.Component.extend({
  filterBy: 'all',

  filteredList: computed('people.[]', 'filterBy', function() {
    if (this.filterBy === 'all') {
      return this.people;
    }
    return this.people.filterBy('attributes.status_id', parseInt(this.filterBy));
  }),

  statusData: computed(function() {
    return Object.keys(PersonModel.STATUSES).map(id => {
      return { id, name: PersonModel.STATUSES[id] };
    });
  }),

  searchPeopleTask: task(function* (q) {
    if (Ember.isBlank(q)) {
      this.sendAction('onSearch', null);
      return
    }

    yield timeout(SEARCH_TIMEOUT);

    this.sendAction('onSearch', q);
  }).restartable(),

  actions: {
    setFilter(value) {
      this.set('filterBy', value);
    },

    scrollToTop() {
      window.scrollTo(0, 0);
    }
  }
});

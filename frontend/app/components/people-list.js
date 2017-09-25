import { isBlank } from '@ember/utils';
import Component from '@ember/component';
import { computed } from '@ember/object';
import PersonModel from '../models/person';
import { task, timeout } from 'ember-concurrency';

const SEARCH_TIMEOUT = 250;
const GROUP_THRESHOLD = 2 * 42;

export default Component.extend({
  filterBy: 'all',
  search: null,

  showGrouped: computed('filteredList.[]', function() {
    return this.get('filteredList.length') > GROUP_THRESHOLD;
  }),

  filteredList: computed('people.[]', 'filterBy', function() {
    if (this.get('filterBy') === 'all') {
      return this.get('people');
    }
    return this.get('people').filterBy(
      'attributes.status_id',
      parseInt(this.get('filterBy'), 10),
    );
  }),

  groupedList: computed('filteredList.[]', function() {
    return this.get('filteredList').toArray().reduce((grouped, person) => {
      let letter = person.attributes.name[0];

      if (grouped[letter] === undefined) {
        grouped[letter] = [];
      }

      grouped[letter].push(person);
      return grouped;
    }, {});
  }),

  statusData: computed(function() {
    return Object.keys(PersonModel.STATUSES).map(id => {
      return { id, name: PersonModel.STATUSES[id] };
    });
  }),

  searchPeopleTask: task(function* (q) {
    if (isBlank(q)) {
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

import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';
import $ from 'jquery';

export default Component.extend({
  store: service(),
  selected: '',
  router: service(),

  init() {
    this._super(...arguments);
  },

  selectedPerson: computed(function() {
    const currentId = this.get('router.currentState.routerJsState.params.person.person_id');
    if (currentId) return this.get('store').find('person', currentId)
  }),

  peopleToSelect: computed(function() {
    return this.get('store').findAll('person', { reload: true })
      .then(people => people.toArray().sort((a, b) => {
        if (a.get('name') < b.get('name')) return -1;
        if (a.get('name') > b.get('name')) return 1;
        return 0;
      })
      )
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  changeText(person) {
    const text = person.get('name') + ' <small>(' + person.get('company.name') + ')</small>';
    const searchFieldText = $('#people-search').children().first();
    if (searchFieldText) searchFieldText.html(text) && searchFieldText.css('color', 'black');
  },

  actions: {
    changePerson(person) {
      this.notifyPropertyChange('selectedPerson');
      person.reload();
      this.get('router').transitionTo('person' , person)
      this.changeText(person);
      //this.get('router').transitionTo('person' , person)
      //  .then (() => {
      //    const text = person.get('name') + ' <small>(' + person.get('company.name') + ')</small>';
      //    const searchFieldText = $('#people-search').children().first();
      //    if (searchFieldText) searchFieldText.html(text) && searchFieldText.css('color', 'black');
      //  });
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    },
  }
});

import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';

export default Component.extend({
  store: service(),
  selected: '',
  router: service(),

  peopleToSelect: computed(function() {
    let people = this.get('store').findAll('person');
    return people;
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },



  actions: {
    changePerson(person) {
      this.set('selected', person);
      person.reload();
      this.get('router').transitionTo('person' , person);
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

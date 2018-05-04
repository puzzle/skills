import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),
  peopleToSelect: computed(function() {
    return this.get('store').findAll('person');
  }),
  selected: '',
  router: service(),
  actions: {
    changePerson(person) {
      person.reload();
      this.get('router').transitionTo('person' , person);
    },
  }
});

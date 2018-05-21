import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({

  originalPeople: computed(function() {
    let people = this.get('company').get('people');
    return people;
  })
});

import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({

  originalPeople: computed(function() {
    return this.get('company.people');
  })
});

import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),

  expertiseCategories: computed('discipline', function() {
    let params = { discipline: this.get('discipline') };
    return this.get('store').query('expertise-category', params);
  })

});

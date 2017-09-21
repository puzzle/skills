import Component from '@ember/component';
import { computed } from '@ember/object';
import Ember from 'ember';

const {
  inject
} = Ember;

export default Component.extend({
  store: inject.service(),

  expertiseCategories: computed('discipline', function() {
    let params = { discipline: this.get('discipline') };
    return this.get('store').query('expertise-category', params);
  })

});

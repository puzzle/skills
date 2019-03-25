import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),

  skills: computed(function() {
    return this.get('store').findAll('skill');
  }),

  parentCategories: computed(function() {
    return this.get('store').query('category', { scope: 'parents' });
  }),

  childCategories: computed(function() {
    return this.get('store').query('category', { scope: 'children' });
  })
});

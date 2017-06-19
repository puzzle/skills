import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  expertiseCategories: computed('discipline', function() {
    let params = { discipline: this.get('discipline') };
    return this.get('store').query('expertise-category', params);
  })

});

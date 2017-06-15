import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  expertiseTopics: computed(function() {
    let params = { category_id: this.get('expertiseCategory').id, person_id: this.get('person').id };
    this.get('store').query('expertise-topic-skill-value', params);
    return this.get('store').query('expertise-topic', params);
  })

});

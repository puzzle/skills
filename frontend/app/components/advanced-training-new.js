import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newAdvancedTraining: computed('personId', function() {
    return this.get('store').createRecord('advanced-training');
  }),

  actions: {
    submit(newAdvancedTraining) {
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newAdvancedTraining.set('person', person)
      return newAdvancedTraining.save()
        .then(() => this.sendAction('submit', newAdvancedTraining));
    }
  }
});

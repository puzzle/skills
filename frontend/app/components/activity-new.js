import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newActivity: computed('personId', function() {
    return this.get('store').createRecord('activity');
  }),

  actions: {
    submit(newActivity) {
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newActivity.set('person', person)
      return newActivity.save()
        .then(() => this.sendAction('submit', newActivity));
    }
  }
});

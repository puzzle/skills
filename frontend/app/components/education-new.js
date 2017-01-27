import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newEducation: computed('personId', function() {
    return this.get('store').createRecord('education');
  }),

  actions: {
    submit(newEducation) {
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newEducation.set('person', person);
      return newEducation.save()
        .then(() => this.sendAction('submit', newEducation));
    }
  }
});

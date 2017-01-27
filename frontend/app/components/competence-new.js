import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newCompetence: computed('personId', function() {
    return this.get('store').createRecord('competence');
  }),

  actions: {
    submit(newCompetence) {
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newCompetence.set('person', person);
      return newCompetence.save()
        .then(() => this.sendAction('submit', newCompetence));
    }
  }
});

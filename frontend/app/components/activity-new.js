import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newActivity: computed('personId', function() {
    return this.get('store').createRecord('activity');
  }),

  actions: {
    submit(newActivity, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newActivity.set('person', person);
      return newActivity.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde hinzugefügt!'))
        .catch(() => {
          this.get('newActivity.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert(`${attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});

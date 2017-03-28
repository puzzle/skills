import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newEducation: computed('personId', function() {
    return this.get('store').createRecord('education');
  }),

  actions: {
    submit(newEducation, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newEducation.set('person', person);
      return newEducation.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde hinzugefügt!'))
        .catch(() => {
          this.get('newEducation.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert(`${attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});

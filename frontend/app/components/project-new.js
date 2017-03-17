import Ember from 'ember';

const { Component, computed, inject } = Ember;

export default Component.extend({
  store: inject.service(),

  newProject: computed('personId', function() {
    return this.get('store').createRecord('project');
  }),

  actions: {
    submit(newProject) {
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newProject.set('person', person);
      return newProject.save()
        .then(() => this.sendAction('submit', newProject))
        .then(() => this.get('notify').success('Projekt wurde hinzugefügt!'))
        .catch(() => {
          this.get('newProject.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert("%@ %@".fmt(attribute, message), { closeAfter: 10000 });
          });
        });
    }
  }
});

import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import Ember from 'ember';

const {
  inject
} = Ember;

export default Component.extend({
  store: inject.service(),

  i18n: service(),

  newProject: computed('personId', function() {
    return this.get('store').createRecord('project');
  }),

  willDestroyElement() {
    if (this.get('newProject.isNew')) {
      this.get('newProject').destroyRecord();
    }
  },

  actions: {
    submit(newProject, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newProject.set('person', person);
      return newProject.save()
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde hinzugefügt!'))
        .catch(() => {
          this.get('newProject.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`project.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});

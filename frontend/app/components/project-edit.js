import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

export default Ember.Component.extend({

  i18n: Ember.inject.service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde aktualisiert!'))
        .catch(() => {
          this.get('project.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`project.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },
    deleteProject(project) {
      project.destroyRecord()
        .then( project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde entfernt!'));
    },
    confirmDestroy(project){
      this.send('deleteProject', project);
    }
  }
});

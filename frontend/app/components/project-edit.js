import Ember from 'ember';

export default Ember.Component.extend({

  i18n: Ember.inject.service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde aktualisiert!'))
        .catch(() => {
          let project = this.get('project');
          let errors = project.get('errors').slice(); // clone array as rollbackAttributes mutates

          project.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
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

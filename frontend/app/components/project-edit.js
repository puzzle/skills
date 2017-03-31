import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde aktualisiert!'))
        .catch(() => {
          this.get('project.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert(`${attribute} ${message}`, { closeAfter: 10000 });
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

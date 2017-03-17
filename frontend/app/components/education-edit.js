import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde aktualisiert!'))
        .catch(() => {
          this.get('education.errors').forEach(({ attribute, message }) => {
            changeset.pushErrors(attribute, message);
            this.get('notify').alert("%@ %@".fmt(attribute, message), { closeAfter: 10000 });
          });
        })

    },
    deleteEducation(education) {
      education.destroyRecord()
        .then( education => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'));
    },
    confirmDestroy(education){
      this.send('deleteEducation', education);
    }
  }
});

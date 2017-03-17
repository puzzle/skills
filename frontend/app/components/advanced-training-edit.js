import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(advanced_training => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde aktualisiert!'))
        .catch(() => {
          this.get('advanced-training.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert("%@ %@".fmt(attribute, message), { closeAfter: 10000 });
          });
        });
    },
    deleteAdvancedTrainings(advancedTraining) {
      advancedTraining.destroyRecord()
        .then(advanced_training => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'))
    },
    confirmDestroy(advancedTraining){
      this.send('deleteAdvancedTrainings', advancedTraining);
    }
  }
});

import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then( activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde aktualisiert!'))
        .catch(() => {
          this.get('activity.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert("%@ %@".fmt(attribute, message), { closeAfter: 10000 });
          });
        });
    },
    deleteActivity(activity, event) {
      activity.destroyRecord()
        .then( activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde entfernt!'));
    },
    confirmDestroy(activity){
      this.send('deleteActivity', activity);
    }
  }
});

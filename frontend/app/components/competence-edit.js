import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(competence => this.sendAction('done'))
        .then(() => this.get('notify').success('Kompetenz wurde aktualisiert!'))
        .catch(() => {
          this.get('competence.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert("%@ %@".fmt(attribute, message), { closeAfter: 10000 });
          });
        });
    },
    deleteCompetence(competence, event) {
      competence.destroyRecord().then(competence => this.sendAction('done'))
           .then(() => this.get('notify').success('Kompetenz wurde entfernt!'));
    },
    confirmDestroy(competence){
      this.send('deleteCompetence', competence)
    }
  }
});

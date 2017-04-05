import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(competence => this.sendAction('done'))
        .then(() => this.get('notify').success('Kompetenzen wurden aktualisiert!'))
        .catch(() => {
          this.get('competence.errors').forEach(({ attribute, message }) => {
            this.get('notify').alert(`${attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});

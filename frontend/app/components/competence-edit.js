import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        competence => this.sendAction('done')
        );
    },
       deleteCompetence(competence, event) {
         competence.destroyRecord().then(
           competence => this.sendAction('done')
           );
       }
  }
});

import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteCompetence(competence) {
      competence.destroyRecord();
    }
  }
});

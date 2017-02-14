import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        advanced_training => this.sendAction('done')
      );
    },
    deleteAdvancedTrainings(advancedTraining, event) {
      advancedTraining.destroyRecord().then(
        advanced_training => this.sendAction('done')
      );
    }
  }
});

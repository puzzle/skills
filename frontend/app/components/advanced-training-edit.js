import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        advanced_training => this.sendAction('done')
      );
    },
    deleteEducation(education, event) {
      education.destroyRecord().then(
        advanced_training => this.sendAction('done')
      );
    }
  }
});

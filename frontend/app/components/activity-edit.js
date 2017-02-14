import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        activity => this.sendAction('done')
      );
    },
    deleteActivity(activity, event) {
      activity.destroyRecord().then(
        activity => this.sendAction('done')
      );
    }
  }
});

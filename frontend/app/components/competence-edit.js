import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset) {
      return changeset.save()
        .then(() => this.sendAction('submit'));
    }
  }
});

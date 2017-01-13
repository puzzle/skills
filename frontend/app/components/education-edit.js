import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset) {
      console.log(changeset)
      return changeset.save()
        .then(() => this.sendAction('submit'));
    }
  }
});

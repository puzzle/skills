import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        education => this.sendAction('done')
      );
    },
    deleteEducation(education) {
      education.destroyRecord().then(
        education => this.sendAction('done')
      );
    },
    confirmDestroy(education){
      this.send('deleteEducation', education);
    }
  }
});

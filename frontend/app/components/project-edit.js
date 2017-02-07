import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save().then(
        project => this.sendAction('done')
      );
    },
    deleteProject(project, event) {
      project.destroyRecord().then(
        project => this.sendAction('done')
      );
    }
  }
});

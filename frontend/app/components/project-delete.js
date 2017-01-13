import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteProject(project) {
    project.destroyRecord();
    }
  }
});

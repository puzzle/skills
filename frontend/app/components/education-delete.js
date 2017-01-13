import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteEducation(education) {
      education.destroyRecord();
    }
  }
});

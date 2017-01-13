import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteAdvancedTraining(advancedTraining) {
      advancedTraining.destroyRecord();
    }
  }
});

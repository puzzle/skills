import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteActivity(activity) {
      activity.destroyRecord();
    }
  }
});

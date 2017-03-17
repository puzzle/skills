import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
  session: Ember.inject.service('session'),

  actions: {
    authenticate() {
      var password = this.controller.get('password');
      var identification = this.controller.get('identification');

      this.get('session').authenticate('authenticator:auth', password, identification).catch((reason) => {
        this.set('errorMessage', reason.message);
      });
      this.transitionTo('people');
    },

    invalidateSession: function(){
      this.get('session').invalidate();
    }
  }
});

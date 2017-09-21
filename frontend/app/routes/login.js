import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  session: Ember.inject.service(),

  actions: {
    authenticate() {
      let password = this.controller.get('password');
      let identification = this.controller.get('identification');

      this.get('session')
        .authenticate('authenticator:auth', password, identification)
        .then(() => {
          this.transitionTo('people');
        })
        .catch(reason => {
          this.get('notify').alert(reason && reason.error || 'Unbekannter Fehler');
        });
    }
  }
});

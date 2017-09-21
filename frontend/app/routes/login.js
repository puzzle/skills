import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Route.extend(UnauthenticatedRouteMixin, {
  session: service(),

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

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
          let full_username = this.get('session.data.authenticated.full_name')
          this.send('findAndTransitionToUser', full_username)
        })
        .catch(reason => {
          this.get('notify').alert(reason && reason.error || 'Unbekannter Fehler');
        });
    },

    findAndTransitionToUser(userName) {
      let people = this.get('store').findAll('person')
      people.then(() => {
        let person = people.filterBy('name', userName)[0]
        if (person == undefined) {
          this.transitionTo('people')
        } else {
          this.transitionTo('person', person.id)
        }
      })
    }

  }
});

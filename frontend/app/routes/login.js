import Ember from 'ember';

export default Ember.Route.extend({
    session: Ember.inject.service('session'),

  actions: {
    authenticate() {
      var password = this.controller.get('password');
      var identification = this.controller.get('identification')

      this.get('session').authenticate('authenticator:auth', password, identification).catch((reason) => {
        this.set('errorMessage', reason.error || reason);
      });
    }
  }
});

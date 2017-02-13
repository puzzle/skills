import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  ajax: Ember.inject.service(),
  session: Ember.inject.service('session'),       

  restore(data) {
  },
  authenticate(password, identification) {

    this.get('ajax').request('/auth/sign_in', {
      method: 'POST',
      data: {
        username: identification,
        password: password
      }
    }).then(function(response){
      return response.api_token      
    }  
      );
    this.session.set('token', token)

  },
  invalidate(data) {
  }
});

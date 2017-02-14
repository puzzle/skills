import Base from 'ember-simple-auth/authenticators/base';

export default Base.extend({
  ajax: Ember.inject.service(),
  session: Ember.inject.service('session'),       

  restore(data) {
    if (Ember.isEmpty(data.token)) {
      throw new Error('No Token to restore found')
    }
    return Ember.RSVP.resolve(data);
  },

  authenticate(password, identification) {
    return this.get('ajax').request('/auth/sign_in', {
        method: 'POST',
        data: {
          username: identification,
          password: password
        }
      }).then(function (response) {
            return {token: response.api_token}
      }, function(xhr, status, error) {
        throw xhr.responseText
        })
  },

  invalidate(data) {
    debugger
  }
});

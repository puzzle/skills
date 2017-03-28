import Ember from 'ember';
import RSVP from 'rsvp'
import Base from 'ember-simple-auth/authenticators/base';
import ENV from '../config/environment';

const { Promise } = RSVP

export default Base.extend({
  ajax: Ember.inject.service(),
  session: Ember.inject.service('session'),

  restore(data) {
    if (Ember.isEmpty(data.token) && ENV.environment != 'development') {
      return Promise.reject(new Error('No Token to restore found'))
    }
    return Promise.resolve(data);
  },

  authenticate(password, identification) {
    return this.get('ajax').request('/auth/sign_in', {
      method: 'POST',
      data: {
        username: identification,
        password: password
      }
    }).then(function (response) {
      return {token: response.api_token,
        ldap_uid: response.ldap_uid}
    }, function(xhr, status, error) {
      throw xhr.responseText
    })
  },

  invalidate(data) {
    return Ember.RSVP.resolve();
  }
});

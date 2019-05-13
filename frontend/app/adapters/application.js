import { underscore } from '@ember/string';
import DS from 'ember-data';
import KeycloakAdapterMixin from 'ember-keycloak-auth/mixins/keycloak-adapter';
import { pluralize } from 'ember-inflector';

export default DS.JSONAPIAdapter.extend(KeycloakAdapterMixin, {
  namespace: 'api',

  authorize(xhr) {
    let api_token = this.get('session.data.authenticated.token');
    let ldap_uid = this.get('session.data.authenticated.ldap_uid');

    if (api_token && ldap_uid) {
      xhr.setRequestHeader('api-token', api_token);
      xhr.setRequestHeader('ldap-uid', ldap_uid);
    }
  },

  pathForType(type) {
    return pluralize(underscore(type));
  }
});

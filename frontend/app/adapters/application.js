import { underscore } from '@ember/string';
import DS from 'ember-data';
import KeycloakAdapterMixin from 'ember-keycloak-auth/mixins/keycloak-adapter';
import { pluralize } from 'ember-inflector';

export default DS.JSONAPIAdapter.extend(KeycloakAdapterMixin, {
  namespace: 'api',

  pathForType(type) {
    return pluralize(underscore(type));
  }
});

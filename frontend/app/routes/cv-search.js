import Route from '@ember/routing/route';
import KeycloakAuthenticatedRouteMixin from 'ember-keycloak-auth/mixins/keycloak-authenticated-route';

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
  queryParams: {
    q: {
      refreshModel: true,
      replace: true
    }
  },

  model({ q }) {
    return q ? this.store.query('person', { q }) : q
  },
});

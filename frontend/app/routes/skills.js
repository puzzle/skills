import KeycloakAuthenticatedRouteMixin from 'ember-keycloak-auth/mixins/keycloak-authenticated-route';
import Route from '@ember/routing/route';

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
});

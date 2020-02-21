import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

@classic
export default class CompaniesRoute extends Route.extend(
  KeycloakAuthenticatedRouteMixin
) {}

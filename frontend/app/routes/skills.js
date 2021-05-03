import classic from "ember-classic-decorator";
import { inject as service } from "@ember/service";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";
import Route from "@ember/routing/route";

@classic
export default class SkillsRoute extends Route.extend(
  KeycloakAuthenticatedRouteMixin
) {
  @service("keycloak-session")
  session;

  @service
  router;
}

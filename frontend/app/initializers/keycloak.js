import KeycloakStub from "../helpers/keycloak-stub";
import ENV from "../config/environment";
import { isPresent } from "@ember/utils";

export function initialize(application) {
  if (ENV.environment === "development" || isPresent(ENV.keycloak.disable)) {
    application.register("service:keycloakStub", KeycloakStub);
    application.inject("route", "session", "service:keycloakStub");
    application.inject("controller", "session", "service:keycloakStub");
    application.inject("adapter", "session", "service:keycloakStub");
  }
}

export default {
  initialize
};

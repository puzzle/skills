import KeycloakStub from "../helpers/keycloak-stub";
import ENV from "../config/environment";

export function initialize(application) {
  if (ENV.environment === "development") {
    application.register("service:keycloakStub", KeycloakStub);
    application.inject("route", "session", "service:keycloakStub");
    application.inject("controller", "session", "service:keycloakStub");
    application.inject("adapter", "session", "service:keycloakStub");
  }
}

export default {
  initialize
};

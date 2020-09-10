import Service from "@ember/service";
import config from "../config/environment";
import $ from "jquery";

export default class EnvSettingsService extends Service {
  fetchEnv() {
    return $.getJSON("/api/env_settings", function(envSettings) {
      config.sentryDsn = envSettings.sentry;
      config.keycloak.url = envSettings.keycloak.url;
      config.keycloak.realm = envSettings.keycloak.realm;
      config.keycloak.clientId = envSettings.keycloak.clientId;
      config.keycloak.secret = envSettings.keycloak.secret;
      config.helplink = envSettings.helplink;
      config.keycloak.disable = envSettings.keycloak.disable;
    });
  }
}

import Application from "@ember/application";
import RSVP from "rsvp";
import Resolver from "./resolver";
import loadInitializers from "ember-load-initializers";
import config from "./config/environment";
import $ from "jquery";

window.Promise = RSVP.Promise;

const App = Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver
});

$.getJSON("/api/env_settings", function(envSettings) {
  config.sentryDsn = envSettings.sentry;
  config.keycloak.url = envSettings.keycloak.url;
  config.keycloak.realm = envSettings.keycloak.realm;
  config.keycloak.clientId = envSettings.keycloak.clientId;
  config.keycloak.secret = envSettings.keycloak.secret;
  config.helplink = envSettings.helplink;
});

loadInitializers(App, config.modulePrefix);

export default App;

import JSONAPIAdapter from "@ember-data/adapter/json-api";
import { underscore } from "@ember/string";
import KeycloakAdapterMixin from "ember-keycloak-auth/mixins/keycloak-adapter";
import { pluralize } from "ember-inflector";

export default JSONAPIAdapter.extend(KeycloakAdapterMixin, {
  namespace: "api",

  pathForType(type) {
    return pluralize(underscore(type));
  }
});

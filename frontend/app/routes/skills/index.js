import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
  queryParams: {
    defaultSet: {
      refreshModel: true,
      replace: true
    },

    category: {
      refreshModel: true,
      replace: true
    },

    title: {
      refreshModel: true,
      replace: true
    }
  },

  model({ defaultSet, category, title }) {
    return this.store.query("skill", { defaultSet, category, title });
  }
});

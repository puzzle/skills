import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import AuthenticatedRouteMixin from "ember-simple-auth/mixins/authenticated-route-mixin";

export default Route.extend(AuthenticatedRouteMixin, {
  ajax: service(),

  queryParams: {
    q: {
      refreshModel: true,
      replace: true
    }
  },

  model({ q }) {
    return this.get("ajax")
      .request("/people", { data: { q } })
      .then(response => response.data);
  },

  actions: {
    reloadPeopleList() {
      this.refresh();
    }
  }
});

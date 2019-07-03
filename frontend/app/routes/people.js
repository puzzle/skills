import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import AuthenticatedRouteMixin from "ember-simple-auth/mixins/authenticated-route-mixin";

export default Route.extend(AuthenticatedRouteMixin, {
  ajax: service(),
  selectedPerson: service(),

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

  redirect(model, transition) {
    if (this.get("selectedPerson.isPresent")) {
      this.transitionTo(
        this.get("selectedPerson.selectedSubRoute"),
        this.get("selectedPerson.personId"),
        { queryParams: this.get("selectedPerson.queryParams") || {} }
      );
    }
  },

  actions: {
    reloadPeopleList() {
      this.refresh();
    },

    willTransition(transition) {
      if (transition.targetName === "people.index")
        this.get("selectedPerson").clear();
    }
  }
});

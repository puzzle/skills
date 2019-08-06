import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
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
    if (this.isTransitioningToSpecificPerson(transition)) return;
    if (this.get("selectedPerson.isPresent")) {
      this.transitionTo(
        this.get("selectedPerson.selectedSubRoute"),
        this.get("selectedPerson.personId"),
        { queryParams: this.get("selectedPerson.queryParams") || {} }
      );
    }
  },

  isTransitioningToSpecificPerson(transition) {
    const transitionPersonId = transition.intent.contexts
      ? transition.intent.contexts.get("firstObject")
      : null;
    return (
      transitionPersonId != null &&
      transitionPersonId != this.get("selectedPerson.personId")
    );
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

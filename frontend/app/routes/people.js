import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

@classic
export default class PeopleRoute extends Route.extend(
  KeycloakAuthenticatedRouteMixin
) {
  @service
  ajax;

  @service
  selectedPerson;

  queryParams = {
    q: {
      refreshModel: true,
      replace: true
    }
  };

  model({ q }) {
    return this.store.query("person", { q });
  }

  redirect(model, transition) {
    if (this.isTransitioningToSpecificPerson(transition)) return;
    if (this.get("selectedPerson.isPresent")) {
      this.transitionTo(
        this.get("selectedPerson.selectedSubRoute"),
        this.get("selectedPerson.personId"),
        { queryParams: this.get("selectedPerson.queryParams") || {} }
      );
    }
  }

  isTransitioningToSpecificPerson(transition) {
    const transitionPersonId = transition.intent.contexts
      ? transition.intent.contexts.get("firstObject")
      : null;
    return (
      transitionPersonId != null &&
      transitionPersonId != this.get("selectedPerson.personId")
    );
  }

  @action
  reloadPeopleList() {
    this.refresh();
  }

  @action
  willTransition(transition) {
    if (transition.targetName === "people.index")
      this.get("selectedPerson").clear();
  }
}

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
    return this.store.findAll("person", { q });
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
    const personRouteInfos = transition.routeInfos.find(
      route => route.name === "person"
    );
    if (personRouteInfos === undefined) return true;
    const transitionPersonId = personRouteInfos.params.person_id;
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

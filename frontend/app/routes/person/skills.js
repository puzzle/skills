import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import RSVP from "rsvp";
import KeycloakAuthenticatedRouteMixin from "ember-keycloak-auth/mixins/keycloak-authenticated-route";

@classic
export default class SkillsRoute extends Route.extend(
  KeycloakAuthenticatedRouteMixin
) {
  @service
  selectedPerson;

  @service
  router;

  queryParams = {
    rated: {
      refreshModel: true,
      replace: true
    }
  };

  doRefresh() {
    this.refresh();
  }

  model(params) {
    const { person_id } = this.paramsFor("person");
    const rated = params.rated;
    return RSVP.hash({
      person: this.store.find("person", person_id),
      peopleSkills: this.store.query("people-skill", { person_id, rated })
    });
  }

  @action
  didTransition() {
    this.set("selectedPerson.personId", this.get("currentModel.person.id"));
    this.set("selectedPerson.selectedSubRoute", this.get("routeName"));
    this.set("selectedPerson.queryParams", this.get("currentModel.person.id"));
  }
}

import Route from "@ember/routing/route";
import AuthenticatedRouteMixin from "ember-simple-auth/mixins/authenticated-route-mixin";
import { inject as service } from "@ember/service";
import RSVP from "rsvp";

export default Route.extend(AuthenticatedRouteMixin, {
  selectedPerson: service(),
  router: service(),
  queryParams: {
    rated: {
      refreshModel: true,
      replace: true
    }
  },

  doRefresh() {
    this.refresh();
  },

  model(params) {
    const person_id = this.get(
      "router.targetState.routerJsState.params.person.person_id"
    );
    const rated = params.rated;
    return RSVP.hash({
      person: this.store.find("person", person_id),
      peopleSkills: this.store.query("people-skill", { person_id, rated })
    });
  },

  actions: {
    didTransition() {
      this.set(
        "selectedPerson.personId",
        this.get("router.targetState.routerJsState.params.person.person_id")
      );
      this.set("selectedPerson.selectedSubRoute", this.get("routeName"));
      this.set(
        "selectedPerson.queryParams",
        this.get("router.targetState.routerJsState.queryParams")
      );
    }
  }
});

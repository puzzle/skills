import Route from "@ember/routing/route";
import AuthenticatedRouteMixin from "ember-simple-auth/mixins/authenticated-route-mixin";
import { inject as service } from "@ember/service";
import RSVP from "rsvp";

export default Route.extend(AuthenticatedRouteMixin, {
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
      "router.currentState.routerJsState.params.person.person_id"
    );
    const rated = params.rated;
    return RSVP.hash({
      person: this.store.find("person", person_id),
      peopleSkills: this.store.query("people-skill", { person_id, rated })
    });
  }
});

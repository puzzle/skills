import Route from "@ember/routing/route";
import { inject as service } from "@ember/service";

export default Route.extend({
  selectedPerson: service(),

  model(params) {
    return this.store.findRecord("person", params.person_id);
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

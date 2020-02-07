import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";

@classic
export default class PersonRoute extends Route {
  @service
  selectedPerson;

  model(params) {
    return this.store.findRecord("person", params.person_id);
  }

  @action
  didTransition() {
    this.set("selectedPerson.personId", this.get("currentModel.id"));
    this.set("selectedPerson.selectedSubRoute", this.get("routeName"));
  }
}

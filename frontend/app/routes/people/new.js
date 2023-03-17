import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Route from "@ember/routing/route";
import { inject as service } from "@ember/service";

@classic
export default class NewRoute extends Route {
  @service store;

  model() {
    return this.store.createRecord("person");
  }

  @action
  createPerson(person) {
    this.send("reloadPeopleList");
    this.transitionTo("person", person);
  }
}

import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Route from "@ember/routing/route";

@classic
export default class NewRoute extends Route {
  model() {
    return this.store.createRecord("person");
  }

  @action
  createPerson(person) {
    this.send("reloadPeopleList");
    this.transitionTo("person", person);
  }
}

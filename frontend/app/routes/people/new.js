import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Route from "@ember/routing/route";

@classic
export default class NewRoute extends Route {
  @action
  abort() {
    this.transitionTo("people");
  }
  @action
  submit(person) {
    this.send("reloadPeopleList");
    this.transitionTo("person", person.id);
  }
}

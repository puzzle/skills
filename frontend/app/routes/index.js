import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";

@classic
export default class IndexRoute extends Route {
  beforeModel() {
    this.transitionTo("people");
  }
}

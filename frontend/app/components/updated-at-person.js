import classic from "ember-classic-decorator";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class UpdatedAtPerson extends Component {
  @service store;

  @service router;

  init() {
    super.init(...arguments);
    const currentId = this.get(
      "router.currentState.routerJsState.params.person.person_id"
    );
    if (currentId)
      this.set("person", this.get("store").find("person", currentId));
  }
}

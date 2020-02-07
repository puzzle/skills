import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class PersonDelete extends Component {
  @service
  router;

  @action
  deletePerson(personToDelete) {
    personToDelete.destroyRecord();
    this.get("router").transitionTo("people");
  }
}

import classic from "ember-classic-decorator";
import Component from "@ember/component";
import { action } from "@ember/object";

@classic
export default class ProjectShow extends Component {
  @action
  toggleEditProject() {
    this.editProject();
  }
}

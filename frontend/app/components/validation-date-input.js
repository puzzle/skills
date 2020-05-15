import Component from "@ember/component";
import { action } from "@ember/object";
import classic from "ember-classic-decorator";

@classic
export default class ValidationDateInput extends Component {
  @action
  setBirthdate(value) {
    this.setDirty();
    this.update(value);
    this.set("input", value);
  }
}

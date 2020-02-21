import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import Component from "@ember/component";

@classic
export default class DisplayError extends Component {
  error = null;

  @computed("error.message")
  get messageIsHTMLDocument() {
    return /<!doctype/i.test(String(this.get("error.message")));
  }
}

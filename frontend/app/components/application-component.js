import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@ember/component";

@classic
export default class ApplicationComponent extends Component {
  @action
  setWithTab(saveAction, select, e) {
    if (e.keyCode == 9 && select.isOpen) {
      this.send(saveAction, select.highlighted);
    }
  }
}

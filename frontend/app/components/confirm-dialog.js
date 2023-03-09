import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
@tagName("span")
export default class ConfirmDialog extends Component {
  @service router;

  @service intl;

  @action
  cancel() {
    //trigger method defined in parent
    this.onCancel();
  }

  @action
  confirm() {
    //trigger method defined in parent
    this.onConfirm();
  }
}

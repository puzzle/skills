import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class ConfirmDialog extends Component {
  @service router;

  @service intl;

  @action
  triggerCancel() {
    //trigger method defined in parent
    this.onCancel();
  }

  @action
  triggerConfirm() {
    //trigger method defined in parent
    this.onConfirm();
  }
}

import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import $ from "jquery";

@classic
export default class ConfirmDialog extends Component {
  @service router;

  @service intl;

  constructor() {
    super(...arguments);
    $(document).on("keyup", event => {
      if (event.keyCode === 27 && this.showModal) {
        this.triggerCancel();
      }
      if (event.keyCode === 13 && this.showModal) {
        this.triggerConfirm();
      }
    });
  }

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

  willDestroy() {
    $(document).off("keyup", this.onKeyUp);
    super.willDestroy();
  }
}

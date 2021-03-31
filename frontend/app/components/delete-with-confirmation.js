import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { tagName } from "@ember-decorators/component";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isPresent } from "@ember/utils";

@classic
@tagName("span")
export default class DeleteWithConfirmation extends Component {
  @service router;

  @service intl;

  @action
  openConfirmation() {
    this.set("showConfirmation", true);
  }

  @action
  cancel() {
    this.set("showConfirmation", false);
  }

  @action
  delete(entry, transitionTo) {
    const message = this.intl.t("delete-confirmation.success", {
      name: entry.instanceToString
    });

    entry.destroyRecord().then(() => {
      this.set("showConfirmation", false);
      if (isPresent(transitionTo)) {
        this.get("router").transitionTo(transitionTo);
      }
      this.get("notify").success(message);
      if (this.didDelete) this.didDelete();
    });
  }
}

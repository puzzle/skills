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
    if (!this.get("router.currentURL").includes("skills")) {
      document
        .getElementById("people-search-header")
        .setAttribute("style", "z-index: 1 !important");
    }
    this.set("showConfirmation", true);
  }

  @action
  cancel() {
    if (!this.get("router.currentURL").includes("skills")) {
      document
        .getElementById("people-search-header")
        .setAttribute("style", "z-index: 1000 !important");
    }
    this.set("showConfirmation", false);
  }

  @action
  delete(entry, transitionTo) {
    if (!this.get("router.currentURL").includes("skills")) {
      document
        .getElementById("people-search-header")
        .setAttribute("style", "z-index: 1000 !important");
    }

    const message = this.intl.t("delete-confirmation.success", {
      name: entry.instanceToString
    });

    this.set("showConfirmation", false);
    entry.destroyRecord().then(() => {
      if (isPresent(transitionTo)) {
        this.get("router").transitionTo(transitionTo);
      }
      this.get("notify").success(message);
      if (this.didDelete) this.didDelete();
    });
  }
}

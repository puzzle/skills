import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isPresent } from "@ember/utils";

export default Component.extend({
  router: service(),
  intl: service(),

  tagName: "span",

  actions: {
    openConfirmation() {
      this.set("showConfirmation", true);
    },

    cancel() {
      this.set("showConfirmation", false);
    },

    delete(entry, transitionTo) {
      const message = this.get("intl").t("delete-confirmation.success", {
        name: entry.get("instanceToString")
      })["string"];

      entry.destroyRecord().then(() => {
        this.set("showConfirmation", false);
        if (isPresent(transitionTo)) {
          this.get("router").transitionTo(transitionTo);
        }
        this.get("notify").success(message);
      });
    }
  }
});

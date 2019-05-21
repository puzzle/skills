import Component from "@ember/component";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),

  didReceiveAttrs() {
    this.set("value", this.get("router._routerMicrolib.state.queryParams.q"));
  },

  actions: {
    searchThroughCVs() {
      const param = this.get("value");

      if (param == "") {
        this.get("router").transitionTo({ queryParams: { q: null } });
      } else {
        this.get("router").transitionTo({ queryParams: { q: param } });
      }
    },

    clearValue() {
      this.set("value", "");
      this.send("searchThroughCVs");
    }
  }
});

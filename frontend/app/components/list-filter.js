import Component from "@ember/component";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),

  init() {
    this._super(...arguments);
    this.filterAction = this.get("filter");
    this.set(
      "value",
      this.get("router.currentState.routerJsState.queryParams.title")
    );
  },

  actions: {
    filterByName() {
      const param = this.get("value");

      if (param == "") {
        this.get("router").transitionTo({ queryParams: { title: null } });
      } else {
        this.get("router").transitionTo({ queryParams: { title: param } });
      }
    }
  }
});

import Component from "@ember/component";
import $ from "jquery";

export default Component.extend({
  init() {
    this._super(...arguments);
    this.set("myStickyOptions", { topSpacing: 160 });
  },

  actions: {
    scrollTo(target) {
      const topOfElement = $(target)[0].offsetTop - 15;
      window.scroll({ top: topOfElement, behavior: "smooth" });
      return false;
    }
  }
});

import Component from "@ember/component";
import { computed } from "@ember/object";
import $ from "jquery";

export default Component.extend({
  myStickyOptions: computed(function() {
    return { topSpacing: 70 };
  }),

  actions: {
    scrollTo(target) {
      const topOfElement = $(target)[0].offsetTop + 80;
      window.scroll({ top: topOfElement, behavior: "smooth" });
      return false;
    }
  }
});

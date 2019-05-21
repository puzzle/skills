import Component from "@ember/component";

export default Component.extend({
  actions: {
    scrollToTop() {
      window.scroll({ top: 0, behavior: "smooth" });
    }
  }
});

import Component from "@ember/component";

export default Component.extend({
  tagName: "tr",

  click() {
    this.sendAction("toggleSkill", this.get("skill"));
  }
});

import Component from "@ember/component";

export default Component.extend({
  actions: {
    setBirthdate(value) {
      this.get("setDirty")();
      this.get("update")(value);
      this.set("input", value);
    }
  }
});

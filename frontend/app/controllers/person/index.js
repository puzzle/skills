import Controller from "@ember/controller";

export default Controller.extend({
  init() {
    this._super(...arguments);
    this.set("sidebarItems", {
      Personalien: "#particulars",
      Kernkompetenzen: "#competences",
      Ausbildung: "#educations",
      Weiterausbildung: "#advancedTrainings",
      Stationen: "#activities",
      Projekte: "#projects"
    });
  }
});

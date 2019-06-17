import Controller from "@ember/controller";
import { inject as service } from "@ember/service";

export default Controller.extend({
  download: service(),

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
  },

  actions: {
    startExport(personId, e) {
      e.preventDefault();

      let url = `/api/people/${personId}.odt`;
      this.get("download").file(url);
    }
  }
});

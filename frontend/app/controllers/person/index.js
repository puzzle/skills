import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";

@classic
export default class IndexController extends Controller {
  @service
  download;

  init() {
    super.init(...arguments);
    this.set("sidebarItems", {
      Personalien: "#particulars",
      Kernkompetenzen: "#competences",
      Ausbildung: "#educations",
      Weiterausbildung: "#advancedTrainings",
      Stationen: "#activities",
      Projekte: "#projects"
    });
  }

  @action
  startExport(personId, e) {
    e.preventDefault();

    let url = `/api/people/${personId}.odt`;
    this.get("download").file(url);
  }
}

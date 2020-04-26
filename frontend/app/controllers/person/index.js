import classic from "ember-classic-decorator";
import Controller from "@ember/controller";

@classic
export default class IndexController extends Controller {
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

  queryParams = ["query"];
}

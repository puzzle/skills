import classic from "ember-classic-decorator";
import Controller from "@ember/controller";

@classic
export default class SkillsController extends Controller {
  // ember needs this to set the active
  // class on the current filter button
  queryParams = ["personId", "rated"];
}

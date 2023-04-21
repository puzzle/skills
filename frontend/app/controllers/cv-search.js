import Controller from "@ember/controller";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
export default class CvSearchController extends Controller {
  @service store;
  @service router;

  queryParams = ["q"];
  q = null;

  @action
  navigateToProfile() {
    window.history.pushState({}, "", "/cv_search?q=" + this.q);
  }
}

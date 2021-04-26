import Controller from "@ember/controller";

export default class CvSearchController extends Controller {
  queryParams = ["q"];
  q = null;
}

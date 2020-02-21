import classic from "ember-classic-decorator";
import Controller from "@ember/controller";

@classic
export default class PeopleController extends Controller {
  queryParams = ["q"];
  q = null;
}

import classic from "ember-classic-decorator";
import Service from "@ember/service";

@classic
export default class SelectedPersonService extends Service {
  personId = null;
  selectedSubRoute = null;
  queryParams = null;

  clear() {
    ["personId", "selectedSubRoute", "queryParams"].forEach(param =>
      this.set(param, null)
    );
  }

  get isPresent() {
    return !!(this.get("personId") && this.get("selectedSubRoute"));
  }
}

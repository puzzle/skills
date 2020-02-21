import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class ExpertiseCategoriesShow extends Component {
  @service store;

  @computed("discipline")
  get expertiseCategories() {
    let params = { discipline: this.get("discipline") };
    return this.get("store").query("expertise-category", params);
  }
}

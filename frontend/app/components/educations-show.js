import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class EducationsShow extends Component {
  @computed("sortedEducations")
  get amountOfEducations() {
    return this.get("sortedEducations.length");
  }

  @sortByYear("educations")
  sortedEducations;

  @action
  toggleEducationNew(triggerNew) {
    this.set("educationNew", triggerNew);
    this.notifyPropertyChange("amountOfEducations");
  }
}

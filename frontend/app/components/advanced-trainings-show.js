import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class AdvancedTrainingsShow extends Component {
  @computed("sortedAdvancedTrainings")
  get amountOfAdvancedTrainings() {
    return this.get("sortedAdvancedTrainings.length");
  }

  @observes("person")
  personChanged() {
    this.send("toggleAdvancedTrainingNew", false);
  }

  @sortByYear("advanced-trainings")
  sortedAdvancedTrainings;

  @action
  toggleAdvancedTrainingNew(triggerNew) {
    this.set("advanced-trainingNew", triggerNew);
    const sortedTrainings = sortByYear("advanced-trainings");
    this.set(
      "sortedAdvancedTrainings",
      triggerNew ? sortedTrainings.volatile() : sortedTrainings
    );
    this.notifyPropertyChange("amountOfAdvancedTrainings");
  }
}

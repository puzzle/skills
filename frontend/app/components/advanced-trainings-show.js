import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action } from "@ember/object";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class AdvancedTrainingsShow extends Component {
  get sortedAdvancedTrainings() {
    return sortByYear(this.args.person.advancedTrainings);
  }

  get amountOfAdvancedTrainings() {
    return this.sortedAdvancedTrainings.length;
  }

  @observes("person")
  personChanged() {
    this.send("toggleAdvancedTrainingNew", false);
  }

  @action
  toggleAdvancedTrainingNew(triggerNew) {
    this.set("advanced-trainingNew", triggerNew);
    this.notifyPropertyChange("amountOfAdvancedTrainings");
  }
}

import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action } from "@ember/object";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class ActivitiesShow extends Component {
  @observes("person")
  personChanged() {
    this.send("toggleActivityNew", false);
  }

  get sortedActivities() {
    return sortByYear(this.args.person.activities);
  }

  get amountOfActivities() {
    return this.sortedActivities.length;
  }

  @action
  toggleActivityNew(triggerNew) {
    this.set("activityNew", triggerNew);
    this.notifyPropertyChange("amountOfActivities");
  }
}

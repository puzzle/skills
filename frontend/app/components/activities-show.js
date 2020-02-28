import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year-old";

@classic
export default class ActivitiesShow extends Component {
  @observes("person")
  personChanged() {
    this.send("toggleActivityNew", false);
  }

  @computed("sortedActivities")
  get amountOfActivities() {
    return this.get("sortedActivities.length");
  }

  @sortByYear("activities")
  sortedActivities;

  @action
  toggleActivityNew(triggerNew) {
    this.set("activityNew", triggerNew);
    this.notifyPropertyChange("amountOfActivities");
  }
}

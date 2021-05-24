import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed, get } from "@ember/object";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class ActivitiesShow extends Component {
  property: "activities";

  @observes("person")
  personChanged() {
    this.send("toggleActivityNew", false);
  }

  @computed("sortedActivities")
  get amountOfActivities() {
    return this.get("sortedActivities.length");
  }

  @action
  sortedActivities() {
    return computed(`${this.property}.@each.{yearTo,yearFrom}`, function() {
      let collection = get(this, this.property);

      if (!collection) return [];
      return sortByYear(this.property);
    });
  }

  @action
  toggleActivityNew(triggerNew) {
    this.set("activityNew", triggerNew);
    this.notifyPropertyChange("amountOfActivities");
  }
}

import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";
import { computed, observer } from "@ember/object";

export default Component.extend({
  personChanged: observer("person", function() {
    this.send("toggleActivityNew", false);
  }),

  amountOfActivities: computed("sortedActivities", function() {
    return this.get("sortedActivities.length");
  }),

  sortedActivities: sortByYear("activities"),

  actions: {
    toggleActivityNew(triggerNew) {
      this.set("activityNew", triggerNew);
      this.set(
        "sortedActivities",
        triggerNew
          ? sortByYear("activities").volatile()
          : sortByYear("activities")
      );
      this.notifyPropertyChange("amountOfActivities");
    }
  }
});

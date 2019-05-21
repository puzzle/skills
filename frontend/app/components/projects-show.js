import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";
import { computed, observer } from "@ember/object";

export default Component.extend({
  sortedProjects: sortByYear("projects").volatile(),

  amountOfProjects: computed("sortedProjects", function() {
    return this.get("sortedProjects.length");
  }),

  projectsChanged: observer("projects.@each", function() {
    if (this.get("projectEditing.isDeleted")) this.set("projectEditing", null);
    this.send("toggleProjectNew", false);
    this.send("toggleProjectEditing");
    this.notifyPropertyChange("sortedProjects");
  }),

  actions: {
    toggleProjectNew(triggerNew) {
      this.set("projectNew", triggerNew);
      this.set(
        "sortedProjects",
        triggerNew ? sortByYear("projects").volatile() : sortByYear("projects")
      );
      this.notifyPropertyChange("amountOfProjects");
    },

    toggleProjectEditing() {
      this.notifyPropertyChange("sortedProjects");
      this.set("projectEditing", null);
    }
  }
});

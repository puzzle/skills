import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";

@classic
export default class ProjectsShow extends Component {
  @(sortByYear("projects").volatile())
  sortedProjects;

  @computed("sortedProjects")
  get amountOfProjects() {
    return this.get("sortedProjects.length");
  }

  @observes("projects.@each")
  projectsChanged() {
    if (this.get("projectEditing.isDeleted")) this.set("projectEditing", null);
    this.send("toggleProjectEditing");
    this.notifyPropertyChange("sortedProjects");
  }

  @action
  toggleProjectNew(triggerNew) {
    this.set("projectNew", triggerNew);
    this.notifyPropertyChange("amountOfProjects");
  }

  @action
  toggleProjectEditing() {
    this.notifyPropertyChange("sortedProjects");
    this.set("projectEditing", null);
  }
}

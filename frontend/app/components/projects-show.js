import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";

@classic
export default class ProjectsShow extends Component {
  @service notify;

  @tracked
  projectNew;

  @tracked
  person;

  @tracked
  projectEditing;

  constructor() {
    super(...arguments);
  }

  get sortedProjects() {
    return sortByYear(this.args.person.projects);
  }

  get amountOfProjects() {
    return this.sortedProjects.length;
  }

  //@observes("projects.@each")
  projectsChanged() {
    //if (this.projectEditing.isDeleted){this.projectEditing = null;}
    this.toggleProjectEditing();
    //this.notifyPropertyChange("sortedProjects");
  }

  @action
  toggleProjectNew(triggerNew) {
    this.projectNew = triggerNew;
    //this.notifyPropertyChange("amountOfProjects");
  }

  @action
  toggleProjectEditing() {
    //this.notifyPropertyChange("sortedProjects");
    this.projectEditing = null;
  }
}

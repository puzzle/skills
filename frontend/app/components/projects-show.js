import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import classic from "ember-classic-decorator";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import sortByYear from "../utils/sort-by-year";

@classic
export default class ProjectsShow extends Component {
  @service notify;

  @tracked
  isNewRecord = false;

  @tracked
  editingProject;

  frozenSortedProject;

  constructor() {
    super(...arguments);
    // addObserver(this, "person", this.personChanged);
    // this is a hack because ember keyboard is not ported to octane yet.
    // normal jquery events using the {{on}} template helper doesn't work for escape key
  }

  get sortedProjects() {
    return !this.editingProject
      ? sortByYear(this.args.projects)
      : this.frozenSortedProject;
  }

  get amountOfProjects() {
    return this.sortedProjects.length;
  }

  @action
  toggleProjectNew() {
    this.isNewRecord = !this.isNewRecord;
  }

  @action
  setEditingProject(project) {
    this.frozenSortedProject = this.sortedProjects;
    this.editingProject = this.editingProject || project;
  }

  @action
  abortProjectEdit() {
    this.editingProject = null;
  }
}

import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import classic from "ember-classic-decorator";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import sortByYear from "../utils/sort-by-year";
import $ from "jquery";

@classic
export default class EducationsShow extends Component {
  @service notify;

  @tracked
  isNewRecord = false;

  @tracked
  editingEducation;

  frozenSortedEducation;

  constructor() {
    super(...arguments);
    // addObserver(this, "person", this.personChanged);
    // this is a hack because ember keyboard is not ported to octane yet.
    // normal jquery events using the {{on}} template helper doesn't work for escape key
    $(document).on("keyup", event => {
      if (event.keyCode == 27) {
        this.editingEducation = null;
        this.isNewRecord = false;
      }
    });
  }

  get sortedEducations() {
    return !this.editingEducation
      ? sortByYear(this.args.person.educations)
      : this.frozenSortedEducation;
  }

  get amountOfEducations() {
    return this.sortedEducations.length;
  }

  @action
  toggleEducationNew() {
    this.isNewRecord = !this.isNewRecord;
  }

  @action
  setEditingEducation(education) {
    this.frozenSortedEducation = this.sortedEducations;
    this.editingEducation = this.editingEducation || education;
  }

  @action
  abortEducationEdit() {
    this.editingEducation = null;
  }
}

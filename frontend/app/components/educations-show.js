import { inject as service } from "@ember/service";
import classic from "ember-classic-decorator";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import SubmitBaseComponent from "./submit-base-component";
import sortByYear from "../utils/sort-by-year";
import $ from "jquery";

@classic
export default class EducationsShow extends SubmitBaseComponent {
  @service notify;

  @tracked
  educationsEditing = false;

  @tracked
  educationNew = false;

  constructor() {
    super(...arguments);
    // this is a hack because ember keyboard is not ported to octane yet.
    // normal jquery events using the {{on}} template helper doesn't work for escape key
    $(document).on("keyup", event => {
      if (event.keyCode == 27) {
        this.educationsEditing = false;
        this.educationNew = false;
      }
    });
  }

  get sortedEducations() {
    return sortByYear(this.args.educations);
  }

  get amountOfEducations() {
    return this.sortedEducations.length;
  }

  @action
  toggleEducationNew() {
    this.educationNew = !this.educationNew;
  }

  @action
  toggleEducationsEditing() {
    this.educationsEditing = !this.educationsEditing;
  }

  @action
  submitPerson() {
    this.submit([this.args.person, this.args.educations.toArray()].flat()).then(
      () => {
        this.notify.success("Successfully saved!");
        $("#educationsHeader")[0].scrollIntoView({ behavior: "smooth" });
        this.toggleEducationsEditing();
      }
    );
  }
}

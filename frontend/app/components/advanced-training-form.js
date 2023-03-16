import { inject as service } from "@ember/service";
import { addObserver } from "@ember/object/observers";
import BaseFormComponent from "./base-form-component";
import { action } from "@ember/object";
import $ from "jquery";
import { tracked } from "@glimmer/tracking";

export default class AdvancedTrainingForm extends BaseFormComponent {
  @service intl;
  @service store;

  @tracked displayModal = false;

  constructor() {
    super(...arguments);
    this.person = this.args.person;
    addObserver(this, "args.person", this.personChanged);
    this.record =
      this.args.advancedTraining || this.store.createRecord("advancedTraining");
    $(document).on("keyup", event => {
      //only listen to form keyup event when modal isn't visible
      if (event.keyCode === 27 && !this.displayModal) {
        /*
         In this if statement we check if any selected element in the dom is a form field,
         if that's the case ESC removes the focus
         if the user isn't in a field we open the modal to ask if he wants to close the form
        */
        if (
          $(document.activeElement).is("input") ||
          $(document.activeElement).is("textarea") ||
          document.activeElement.classList.contains(
            "ember-basic-dropdown-trigger"
          )
        ) {
          $(document.activeElement).blur();
        } else {
          this.openModal();
        }
      }
    });
  }

  setInitialState() {
    this.record = this.store.createRecord("advancedTraining");
    this.args.done();
  }

  beforeSubmit() {
    this.record.person = this.person;
  }

  handleSubmitError() {
    this.record.person = null;
  }

  handleSubmitSuccessful(savedRecords) {
    this.args.done();
    this.notify.success("Successfully saved!");
    if (this.newAfterSubmit) {
      this.setInitialState();
      this.newAfterSubmit = false;
    } else {
      $("#advancedTrainingsHeader")[0].scrollIntoView({ behavior: "smooth" });
    }
  }

  @action
  personChanged() {
    this.args.done();
  }

  @action
  abort(event) {
    if (event) event.preventDefault();
    $("#advancedTrainingsHeader")[0].scrollIntoView({ behavior: "smooth" });
    this.record.rollbackAttributes();
    this.args.done();
  }

  @action
  submitAndNew(recordsToSave) {
    this.newAfterSubmit = true;
    super.submit(recordsToSave);
  }

  @action
  openModal() {
    this.displayModal = true;
  }

  @action
  closeModal() {
    this.displayModal = false;
  }

  willDestroy() {
    //remove keyup event listener on close
    $(document).off("keyup", this.onKeyUp);
    super.willDestroy();
  }
}

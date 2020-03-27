import { inject as service } from "@ember/service";
import { addObserver } from "@ember/object/observers";
import BaseFormComponent from "./base-form-component";
import { action } from "@ember/object";
import $ from "jquery";

export default class EducationForm extends BaseFormComponent {
  @service intl;
  @service store;

  constructor() {
    super(...arguments);
    this.person = this.args.person;
    addObserver(this, "args.person", this.personChanged);
    this.record = this.args.education || this.store.createRecord("education");
  }

  setInitialState() {
    this.record = this.store.createRecord("education");
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
      $("#educationsHeader")[0].scrollIntoView({ behavior: "smooth" });
    }
  }

  @action
  personChanged() {
    this.args.done();
  }

  @action
  abort(event) {
    if (event) event.preventDefault();
    $("#educationsHeader")[0].scrollIntoView({ behavior: "smooth" });
    this.record.rollbackAttributes();
    this.args.done();
  }

  @action
  submitAndNew(recordsToSave) {
    this.newAfterSubmit = true;
    super.submit(recordsToSave);
  }
}

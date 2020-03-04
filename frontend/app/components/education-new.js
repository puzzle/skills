import { inject as service } from "@ember/service";
import SubmitBaseComponent from "./submit-base-component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class EducationNew extends SubmitBaseComponent {
  @service store;
  @service intl;
  @service notify;

  @tracked newEducation = this.store.createRecord("education");

  willDestroy() {
    if (this.newEducation.isNew) {
      this.newEducation.destroyRecord();
    }
  }

  setInitialState() {
    this.newEducation = this.store.createRecord("education");
    this.args.done();
  }

  @action
  abortNew(event) {
    event.preventDefault();
    this.args.done();
  }

  @action
  submitNewEducation(initNew, event) {
    event.preventDefault();
    this.newEducation.person = this.args.person;
    this.submit([this.newEducation]).then(savedRecords => {
      if (savedRecords !== undefined) {
        this.args.done();
        if (initNew) {
          this.setInitialState();
        }
        this.notify.success("Ausbildung wurde hinzugefügt!");
      } else {
        this.newEducation.person = null;
      }
    });
  }
}

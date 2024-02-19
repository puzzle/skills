import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table"
export default class extends Controller {
  static targets = ["row", "editButton" ,"saveButton", "cancelButton"]
  connect() {

  }

  editRow() {
    this.triggerButtonDisplay("none", "block");
    this.rowTarget.contentEditable = "true";
    this.rowTarget.focus();
  }

  cancelRow() {
    this.triggerButtonDisplay("block", "none");
    this.rowTarget.contentEditable = "false";
  }

  triggerButtonDisplay(editButtonDisplay, actionButtonDisplay) {
    this.cancelButtonTarget.style.display = actionButtonDisplay;
    this.saveButtonTarget.style.display = actionButtonDisplay;
    this.editButtonTarget.style.display = editButtonDisplay;
  }
}

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

  saveData({params}) {
    const skill = params.skill;
    const url = "skills/" + skill.id;
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    let updateSkill = {
      "title": this.rowTarget.cells[0].textContent,
      "radar": skill.radar,
      "portfolio": skill.portfolio,
      "default_set": skill.default_set
    }
    // Define the request options
    const options = {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify(updateSkill)
    };
    this.doRequest(options, url);
  }

  doRequest(options, url) {
    // Send the request using Fetch API
    fetch(url, options)
        .then(response => {
          console.log("Problem")
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();  // Parse response JSON
        })
  }
}

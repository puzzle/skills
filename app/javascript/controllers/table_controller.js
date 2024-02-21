import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table"
export default class extends Controller {
  static targets = ["childSelect"];
  connect() {

  }

  adjustChildren() {
    console.log("Adjust options");
  }
}

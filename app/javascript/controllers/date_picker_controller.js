import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {

  static targets = [ "hideable" ]

  toggleTargets() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden;
      el.querySelectorAll('select').forEach((select) => {
        select.value = "";
      });
    });
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {


  static targets = [ "hideable" ]

  connect() {
    this.hideableTargets.forEach((el) => {
      el.querySelectorAll('select').forEach((select) => {
        select.disabled = el.hidden;
        select.hidden = el.hidden;
      });
    });
  }

  toggleTargets() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden;
      
      el.querySelectorAll('select').forEach((select) => {
        select.hidden = !select.hidden;
        select.disabled = !select.disabled;
      });
    });
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visibility"
export default class extends Controller {


  static targets = [ "hideable" ]

  connect() {
    this.hideableTargets.forEach((el) => {
      el.querySelectorAll('select').forEach((select) => {
        let is_active = /^true$/i.test(select.dataset.activeDefault);
        select.disabled = is_active;
        select.hidden = is_active;
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

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {

  static targets = [ "hideable" ]

  connect() {
  }

  toggleTargets() {
    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden;
      this.setSelects(el, "value", "");
    });
  }


  setSelects(parent, property, value){
    parent.querySelectorAll('select').forEach((select) => {
      select[property] = value;
    });
  }
}

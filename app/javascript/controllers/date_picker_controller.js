import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {

  static targets = [ "hideable" ]
  sameDate = false

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
      if(this.sameDate){
        this.sameDate = false;
        el.querySelectorAll('select').forEach((select) => {
          select.disabled = true;
        });
        return;
      }
      el.hidden = !el.hidden;
      el.querySelectorAll('select').forEach((select) => {
        select.disabled = !select.disabled;
      });
    });
  }

  sameDateToggle(){
    this.sameDate = !this.sameDate;
    let endDatePicker = document.querySelector("#end_date_picker")
    endDatePicker.hidden = this.sameDate;
    if (!this.sameDate) return;
    endDatePicker.querySelectorAll('select').forEach((select) => {
      select.disabled = false;
    });
  }

  changeDate(event) {
    if(this.sameDate){
      let targetId = event.target.id.replace("from", "to");
      document.querySelector(`#${targetId}`).value = event.target.value
    }
  }
}

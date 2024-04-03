import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {

  static targets = [ "hideable", "hiddenField" ]

  toggleTillToday($event) {
    this.toggleTargets($event);
    let endDatePickerHidden = document.querySelector("#end_date_picker").hidden
    this.setTillTodayLabelHidden(!endDatePickerHidden)
  }

  toggleSameDate($event) {
    this.toggleTargets($event);
    this.setTillTodayLabelHidden(true)
    this.hiddenFieldTargets.forEach((el) => {
      el.value = el.value == "false" ? "true" : "false";
    });
  }

  toggleTargets(event){
    let labels = Array.from(event.target.querySelectorAll(".button-label"))
    let elmns = labels.concat(this.hideableTargets)
    elmns.forEach((el) => {
      el.hidden = !el.hidden;
      console.log(el);
      el.querySelectorAll('select').forEach((select) => {
        select.value = "";
      });
    });
  }

  setTillTodayLabelHidden(isHidden) {
    let till_today = document.querySelector("#till_today_label")
    till_today.hidden = isHidden;
  }
}

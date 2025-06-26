import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-picker"
export default class extends Controller {

  static targets = [ "hideable", "monthTo", "yearTo"]

  toggleTargets() {
    const wasHidden = this.hideableTargets[0].hidden;

    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden;

      if (el.hidden) {
        el.querySelectorAll('select').forEach((select) => {
          select.value = "";
        });
      } else if (wasHidden) {
        const monthFrom = this.element.querySelector('select[name$="[month_from]"]')
        const yearFrom = this.element.querySelector('select[name$="[year_from]"]')

        if (monthFrom && this.hasMonthToTarget) {
          this.monthToTarget.value = monthFrom.value;
        }
        if (yearFrom && this.hasYearToTarget) {
          this.yearToTarget.value = yearFrom.value;
        }
      }
    });
  }
}

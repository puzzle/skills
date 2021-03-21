import Model, { attr } from "@ember-data/model";

export default Model.extend({
  monthFrom: attr("number"),
  yearFrom: attr("number"),
  monthTo: attr("number"),
  yearTo: attr("number"),

  isYearValid(year) {
    if (year.length == 4 && year > 0) return true;
    return false;
  },

  missesMonths() {
    return !this.monthFrom || (!this.monthTo && this.yearTo);
  }
});

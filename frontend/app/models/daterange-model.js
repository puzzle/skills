import DS from "ember-data";

export default DS.Model.extend({
  monthFrom: DS.attr("number"),
  yearFrom: DS.attr("number"),
  monthTo: DS.attr("number"),
  yearTo: DS.attr("number"),

  isYearValid(year) {
    if (year.length == 4 && year > 0) return true;
    return false;
  }
});

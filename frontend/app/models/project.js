import { attr, belongsTo, hasMany } from "@ember-data/model";
import DaterangeModel from "./daterange-model";
import { computed } from "@ember/object";
import { htmlSafe } from "@ember/template";

export default DaterangeModel.extend({
  title: attr("string"),
  description: attr("string"),
  role: attr("string"),
  technology: attr("string"),
  person: belongsTo("person"),

  projectTechnologies: hasMany("project-technology"),

  instanceToString: computed("title", function() {
    return this.title;
  }),

  lineBreakDescription: computed("description", function() {
    let description = this.description;
    if (description == null) {
      return "";
    }
    return htmlSafe(description.replace(/\n/g, "<br>"));
  }),

  lineBreakRole: computed("role", function() {
    let role = this.role;
    if (role == null) {
      return "";
    }
    return htmlSafe(role.replace(/\n/g, "<br>"));
  }),

  lineBreakTechnology: computed("technology", function() {
    let technology = this.technology;
    if (technology == null) {
      return "";
    }
    return htmlSafe(technology.replace(/\n/g, "<br>"));
  })
});

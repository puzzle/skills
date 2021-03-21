import { attr, belongsTo } from "@ember-data/model";
import DaterangeModel from "./daterange-model";
import { computed } from "@ember/object";
import { htmlSafe } from "@ember/template";

export default DaterangeModel.extend({
  description: attr("string"),
  role: attr("string"),
  person: belongsTo("person"),

  instanceToString: computed("role", function() {
    return this.role;
  }),

  lineBreakDescription: computed("description", function() {
    let description = this.description;
    if (description == null) {
      return "";
    }
    return htmlSafe(description.replace(/\n/g, "<br>"));
  })
});

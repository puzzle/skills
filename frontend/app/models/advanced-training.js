import { attr, belongsTo } from "@ember-data/model";
import DaterangeModel from "./daterange-model";
import { computed } from "@ember/object";
import { htmlSafe } from "@ember/template";
import { inject as service } from "@ember/service";

export default DaterangeModel.extend({
  intl: service(),

  description: attr("string"),
  person: belongsTo("person"),

  instanceToString: computed("description", function() {
    return this.intl.t("advancedTraining.name").toString();
  }),

  lineBreakDescription: computed("description", function() {
    let description = this.description;
    if (description == null) {
      return "";
    }
    return htmlSafe(description.replace(/\n/g, "<br>"));
  })
});

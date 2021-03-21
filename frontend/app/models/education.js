import { attr, belongsTo } from "@ember-data/model";
import DaterangeModel from "./daterange-model";
import { computed } from "@ember/object";

export default DaterangeModel.extend({
  title: attr("string"),
  location: attr("string"),
  person: belongsTo("person"),

  instanceToString: computed("title", function() {
    return this.title;
  })
});

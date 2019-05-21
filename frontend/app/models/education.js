import DS from "ember-data";
import DaterangeModel from "./daterange-model";
import { computed } from "@ember/object";

export default DaterangeModel.extend({
  title: DS.attr("string"),
  location: DS.attr("string"),
  person: DS.belongsTo("person"),

  instanceToString: computed("title", function() {
    return this.get("title");
  })
});

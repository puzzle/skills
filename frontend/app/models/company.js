import Model, { attr } from "@ember-data/model";
import { computed } from "@ember/object";

export default Model.extend({
  name: attr("string"),
  createdAt: attr("date"),
  updatedAt: attr("date"),

  instanceToString: computed("name", function() {
    return this.name;
  })
});

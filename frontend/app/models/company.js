import DS from "ember-data";
import { computed } from "@ember/object";

export default DS.Model.extend({
  name: DS.attr("string"),
  createdAt: DS.attr("date"),
  updatedAt: DS.attr("date"),

  instanceToString: computed("name", function() {
    return this.get("name");
  })
});

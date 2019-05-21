import DS from "ember-data";
import { computed } from "@ember/object";

export default DS.Model.extend({
  category: DS.attr("string"),
  quantity: DS.attr("number"),
  company: DS.belongsTo("company"),

  instanceToString: computed("category", function() {
    return this.get("category");
  })
});

import DS from "ember-data";
import { computed } from "@ember/object";

export default DS.Model.extend({
  location: DS.attr("string"),
  company: DS.belongsTo("company"),

  instanceToString: computed("location", function() {
    return this.get("location");
  })
});

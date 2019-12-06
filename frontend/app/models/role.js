import DS from "ember-data";
import { computed } from "@ember/object";

export default DS.Model.extend({
  name: DS.attr("string"),

  personRoles: DS.hasMany("people-role"),

  instanceToString: computed("name", function() {
    return this.get("name");
  })
});

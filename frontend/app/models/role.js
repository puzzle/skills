import Model, { attr, hasMany } from "@ember-data/model";
import { computed } from "@ember/object";

export default Model.extend({
  name: attr("string"),

  personRoles: hasMany("person-role"),

  instanceToString: computed("name", function() {
    return this.name;
  })
});

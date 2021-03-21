import Model, { attr, belongsTo } from "@ember-data/model";
import { computed } from "@ember/object";

export default Model.extend({
  percent: attr("number"),
  level: attr("string"),

  person: belongsTo("person"),
  role: belongsTo("role"),
  personRoleLevel: belongsTo("person-role-level"),

  instanceToString: computed("role", function() {
    return this.get("role.name");
  })
});

import DS from "ember-data";
import { computed } from "@ember/object";

export default DS.Model.extend({
  percent: DS.attr("number"),

  person: DS.belongsTo("person"),
  role: DS.belongsTo("role"),
  person_role_level: DS.belongsTo("person-role-level"),

  instanceToString: computed("role", function() {
    return this.get("role.name");
  })
});

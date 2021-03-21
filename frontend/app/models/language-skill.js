import Model, { attr, belongsTo } from "@ember-data/model";
import { computed } from "@ember/object";
export default Model.extend({
  language: attr("string"),
  level: attr("string"),
  certificate: attr("string"),

  person: belongsTo("person"),

  instanceToString: computed("language", function() {
    return this.language;
  })
});

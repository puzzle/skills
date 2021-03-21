import Model, { attr, hasMany } from "@ember-data/model";

export default Model.extend({
  name: attr("string"),
  discipline: attr("string"),
  expertiseTopics: hasMany("expertise-topic")
});

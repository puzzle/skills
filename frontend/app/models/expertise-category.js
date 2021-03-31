import DS from "ember-data";

export default DS.Model.extend({
  name: DS.attr("string"),
  discipline: DS.attr("string"),
  expertiseTopics: DS.hasMany("expertise-topic")
});

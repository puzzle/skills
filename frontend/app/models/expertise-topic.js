import Model, { attr, belongsTo, hasMany } from "@ember-data/model";

export default Model.extend({
  name: attr("string"),
  userTopic: attr("boolean"),
  expertiseCategory: belongsTo("expertise-category"),
  expertiseTopicSkillValues: hasMany("expertise-topic-skill-value")
});

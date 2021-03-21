import Model, { attr, belongsTo } from "@ember-data/model";

const ExpertiseTopicSkillValue = Model.extend({
  yearsOfExperience: attr("string"),
  numberOfProjects: attr("string"),
  lastUse: attr("string"),
  skillLevel: attr("string"),
  comment: attr("string"),
  person: belongsTo("person"),
  expertiseTopic: belongsTo("expertise-topic")
});

ExpertiseTopicSkillValue.reopenClass({
  SKILL_LEVELS: ["trainee", "junior", "professional", "senior", "expert"]
});

export default ExpertiseTopicSkillValue;

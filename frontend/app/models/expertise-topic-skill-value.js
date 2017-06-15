import DS from 'ember-data';

const ExpertiseTopicSkillValue = DS.Model.extend({
  yearsOfExperience: DS.attr('string'),
  numberOfProjects: DS.attr('string'),
  lastUse: DS.attr('string'),
  skillLevel: DS.attr('string'),
  comment: DS.attr('string'),
  person: DS.belongsTo('person'),
  expertiseTopic: DS.belongsTo('expertise-topic'),
});

ExpertiseTopicSkillValue.reopenClass({
  SKILL_LEVELS: [
    'trainee',
    'junior',
    'professional',
    'senior',
    'expert'
  ]
});

export default ExpertiseTopicSkillValue;

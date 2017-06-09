import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  userTopic: DS.attr('boolean'),
  expertiseCategory: DS.belongsTo('expertise-category'),
  expertiseTopicSkillValues: DS.hasMany('expertise-topic-skill-value')
});

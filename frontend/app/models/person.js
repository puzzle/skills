import DS from 'ember-data';

const Person = DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  picturePath: DS.attr('string'),
  language: DS.attr('string'),
  location: DS.attr('string'),
  martialStatus: DS.attr('string'),
  origin: DS.attr('string'),
  role: DS.attr('string'),
  title: DS.attr('string'),
  competences: DS.attr('string'),
  updatedAt: DS.attr('date'),

  company: DS.belongsTo('company'),

  variationName: DS.attr('string'),
  originPersonId: DS.attr('number'),

  educations: DS.hasMany('education'),
  personCompetences: DS.hasMany('person-competence'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  expertiseTopicSkillValues: DS.hasMany('expertise-topic-skill-value'),
});

export default Person;

import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  picturePath: DS.attr('string'),
  language: DS.attr('string'),
  "location": DS.attr('string'),
  martialStatus: DS.attr('string'),
  origin: DS.attr('string'),
  role: DS.attr('string'),
  title: DS.attr('string'),
  competences: DS.hasMany('competence'),
  educations: DS.hasMany('education'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  status: DS.belongsTo('status')
});

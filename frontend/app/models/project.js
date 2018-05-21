import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  role: DS.attr('string'),
  technology: DS.attr('string'),
  year_from: DS.attr('string'),
  year_to: DS.attr('string'),
  person: DS.belongsTo('person'),

  projectTechnologies: DS.hasMany('project-technology')
});

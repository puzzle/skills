import DS from 'ember-data';

export default DS.Model.extend({
  level: DS.attr('number'),
  interest: DS.attr('number'),
  certificate: DS.attr('boolean'),
  core_competence: DS.attr('boolean'),

  person: DS.belongsTo('person'),
  skill: DS.belongsTo('skill'),
});

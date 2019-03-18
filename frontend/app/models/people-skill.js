import DS from 'ember-data';

export default DS.Model.extend({
  level: DS.attr('integer'),
  interest: DS.attr('integer'),
  certificate: DS.attr('boolean'),
  core_competence: DS.attr('boolean'),

  person: DS.belongsTo('person'),
  skill: DS.belongsTo('skill'),
});

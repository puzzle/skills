import DS from 'ember-data';

export default DS.Model.extend({
  category: DS.attr('string'),
  skills: DS.attr('string'),
  company: DS.belongsTo('array')
});

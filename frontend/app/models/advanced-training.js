import DS from 'ember-data';

export default DS.Model.extend({
  description: DS.attr('string'),
  year_from: DS.attr('string'),
  year_to: DS.attr('string'),
  person: DS.belongsTo('person') 
});

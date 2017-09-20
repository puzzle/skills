import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  location: DS.attr('string'),
  year_from: DS.attr('number'),
  year_to: DS.attr('number'),
  person: DS.belongsTo('person')
});

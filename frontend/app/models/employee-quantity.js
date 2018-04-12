import DS from 'ember-data';

export default DS.Model.extend({
  category: DS.attr('string'),
  quantity: DS.attr('number'),
  company: DS.belongsTo('company')
});

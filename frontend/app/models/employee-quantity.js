import DS from 'ember-data';

export default DS.Model.extend({
  category: DS.attr('string'),
  amount: DS.attr('number'),
  company: DS.belongsTo('company')
});

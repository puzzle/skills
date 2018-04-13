import DS from 'ember-data';

export default DS.Model.extend({
  category: DS.attr('string'),
  skills: DS.attr('array'),
  company: DS.belongsTo('company')
});


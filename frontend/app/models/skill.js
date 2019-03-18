import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr('string'),
  radar: DS.attr('string'),
  portfolio: DS.attr('string'),
  defaultSet: DS.attr('boolean', { allowNull: true }),

  people: DS.hasMany('person'),
  category: DS.belongsTo('category'),
  parentCategory: DS.belongsTo('category', { inverse: null })
});

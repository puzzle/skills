import DS from 'ember-data';

export default DS.Model.extend({
  offer: DS.attr('array'),
  project: DS.belongsTo('project')
});

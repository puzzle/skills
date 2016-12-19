import DS from 'ember-data';

export default DS.Model.extend({
  status: DS.attr('string'),
  persons: DS.hasMany('person')
});

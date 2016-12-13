import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  profile_picture: DS.attr('string'),
  language: DS.attr('string'),
  location: DS.attr('string'),
  martial_status: DS.attr('string'),
  origin: DS.attr('string'),
  role: DS.attr('string'),
  title: DS.attr('string'),
  type: DS.attr('string')
});

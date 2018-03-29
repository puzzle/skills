import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  web: DS.attr('string'),
  email: DS.attr('string'),
  phone: DS.attr('string'),
  partnermanager: DS.attr('string'),
  contactPerson: DS.attr('string'),
  emailContactPerson: DS.attr('string'),
  phoneContactPerson: DS.attr('string'),
  crm: DS.attr('string'),
  level: DS.attr('string'),
  picture: DS.attr('string'),
  myCompany: DS.attr('boolean'),
  createdAt: DS.attr('date'),
  updatedAt: DS.attr('date'),

  locations: DS.hasMany('location'),
  employeeQuantities: DS.hasMany('employeeQuantity'),
  people: DS.hasMany('person')


});

import DS from 'ember-data';
import Ember from 'ember';



const Person = DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  picturePath: DS.attr('string'),
  language: DS.attr('string'),
  location: DS.attr('string'),
  martialStatus: DS.attr('string'),
  origin: DS.attr('string'),
  role: DS.attr('string'),
  title: DS.attr('string'),
  statusId: DS.attr('string'),

  competences: DS.hasMany('competence'),
  educations: DS.hasMany('education'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  personVariations: DS.hasMany('person-variation'),

  status: Ember.computed('statusId', function() {
    return Person.STATUSES[this.get('statusId')];
  })
});

Person.reopenClass({
  STATUSES: {
    1: 'Mitarbeiter',
    2: 'Partner',
    3: 'Bewerber',
    4: 'Ex Mitarbeiter'
  }
});

export default Person;

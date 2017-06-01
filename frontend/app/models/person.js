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
  competences: DS.attr('string'),
  statusId: DS.attr('string', { defaultValue: 1 }),

  variationName: DS.attr('string'),
  originPersonId: DS.attr('number'),

  educations: DS.hasMany('education'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  personVariations: DS.hasMany('person'),

  status: Ember.computed('statusId', function() {
    return Person.STATUSES[this.get('statusId')];
  })
});

Person.reopenClass({
  STATUSES: {
    1: 'Mitarbeiter',
    2: 'Ex Mitarbeiter',
    3: 'Bewerber',
    4: 'Partner'
  }
});

export default Person;

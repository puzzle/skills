import { computed } from '@ember/object';
import DS from 'ember-data';

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
  statusId: DS.attr('number', { defaultValue: 1 }),
  updatedAt: DS.attr('date'),

  company: DS.belongsTo('company'),

  variationName: DS.attr('string'),
  originPersonId: DS.attr('number'),

  educations: DS.hasMany('education'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  expertiseTopicSkillValues: DS.hasMany('expertise-topic-skill-value'),

  status: computed('statusId', function() {
    return Person.STATUSES[this.get('statusId')];
  }),

  isPartner: computed('statusId', function() {
    return this.get('statusId') === 4;
  }),
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

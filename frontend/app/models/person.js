import DS from 'ember-data';
import { computed } from '@ember/object';

const Person = DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  picturePath: DS.attr('string'),
  language: DS.attr('string'),
  location: DS.attr('string'),
  maritalStatus: DS.attr('string'),
  nationality: DS.attr('string', { defaultValue: 'CH' }),
  nationality2: DS.attr('string'),
  roles: DS.hasMany('role'),
  title: DS.attr('string'),
  competences: DS.attr('string'),
  updatedAt: DS.attr('date'),

  company: DS.belongsTo('company'),

  educations: DS.hasMany('education'),
  personCompetences: DS.hasMany('person-competence'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  expertiseTopicSkillValues: DS.hasMany('expertise-topic-skill-value'),

  toString: computed('name', function() {
    return this.get('name');
  })
});

Person.reopenClass({
  MARITAL_STATUSES: { single: 'ledig',
    married: 'verheiratet',
    registered_partnership: 'eingetragene Partnerschaft',
    divorced: 'geschieden' }
});

export default Person;

import DS from 'ember-data';
import { computed } from '@ember/object';

const Person = DS.Model.extend({
  name: DS.attr('string'),
  birthdate: DS.attr('date'),
  picturePath: DS.attr('string'),
  location: DS.attr('string'),
  maritalStatus: DS.attr('string'),
  nationality: DS.attr('string', { defaultValue: 'CH' }),
  nationality2: DS.attr('string'),
  title: DS.attr('string'),
  competences: DS.attr('string'),
  email: DS.attr('string'),
  department: DS.attr('string'),
  updatedAt: DS.attr('date'),

  company: DS.belongsTo('company'),

  educations: DS.hasMany('education'),
  personCompetences: DS.hasMany('person-competence'),
  advancedTrainings: DS.hasMany('advanced-training'),
  activities: DS.hasMany('activity'),
  projects: DS.hasMany('project'),
  expertiseTopicSkillValues: DS.hasMany('expertise-topic-skill-value'),
  languageSkills: DS.hasMany('language-skill'),
  peopleRoles: DS.hasMany('people-role'),
  peopleSkills: DS.hasMany('people-skill'),

  instanceToString: computed('name', function() {
    return this.get('name');
  })
});

Person.reopenClass({
  MARITAL_STATUSES: { single: 'ledig',
    married: 'verheiratet',
    registered_partnership: 'eingetragene Partnerschaft',
    divorced: 'geschieden' },

  DEPARTMENTS: ['/dev/one', '/dev/two', '/dev/tre',
    '/dev/ruby', '/mid', '/ux', '/zh',
    '/sys', '/bs', 'Funktionsbereiche'],

  ROLE_LEVELS: ['Keine', 'S1', 'S2',
    'S3', 'S4', 'S5', 'S6']
});

export default Person;

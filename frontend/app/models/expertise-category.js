import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  discipline: DS.attr('discipline'),
  expertiseTopics: DS.hasMany('expertise-topic')
});

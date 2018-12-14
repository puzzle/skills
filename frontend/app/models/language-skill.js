import DS from 'ember-data';
import { computed } from '@ember/object';
export default DS.Model.extend({
  language: DS.attr('string'),
  level: DS.attr('string'),
  certificate: DS.attr('string'),

  person: DS.belongsTo('person'),

  toString: computed('language', function() {
    return this.get('language');
  })
});

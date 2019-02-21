import DS from 'ember-data';
import { computed } from '@ember/object';

export default DS.Model.extend({
  level: DS.attr('string'),
  percent: DS.attr('number'),

  person: DS.belongsTo('person'),
  role: DS.belongsTo('role'),

  instanceToString: computed('role', function() {
    return this.get('role.name');
  })
});

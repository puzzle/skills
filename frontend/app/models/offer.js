import DS from 'ember-data';
import { computed } from '@ember/object';

export default DS.Model.extend({
  category: DS.attr('string'),
  offer: DS.attr('array'),
  company: DS.belongsTo('company'),

  instanceToString: computed('category', function() {
    return this.get('category');
  })
});

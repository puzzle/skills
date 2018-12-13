import DS from 'ember-data';
import DaterangeModel from './daterange-model';
import { computed } from '@ember/object';

export default DaterangeModel.extend({
  description: DS.attr('string'),
  role: DS.attr('string'),
  person: DS.belongsTo('person'),

  toString: computed('role', function() {
    return this.get('role');
  })
});

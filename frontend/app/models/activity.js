import DS from 'ember-data';
import DaterangeModel from './daterange-model';
import { computed } from '@ember/object';
import { htmlSafe } from '@ember/template';

export default DaterangeModel.extend({
  description: DS.attr('string'),
  role: DS.attr('string'),
  person: DS.belongsTo('person'),

  instanceToString: computed('role', function() {
    return this.get('role');
  }),

  lineBreakDescription: computed('description', function() {
    let description = this.get('description')
    if (description == null) {return ''}
    return htmlSafe(description.replace(/\n/g, '<br>'));
  })
});

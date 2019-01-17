import DS from 'ember-data';
import DaterangeModel from './daterange-model';
import { computed } from '@ember/object';
import { htmlSafe } from '@ember/template';

export default DaterangeModel.extend({
  description: DS.attr('string'),
  person: DS.belongsTo('person'),

  toString: computed('description', function() {
    return this.get('intl').t('advancedTraining.name').toString();
  }),

  lineBreakDescription: computed('description', function() {
    let description = this.get('description')
    if (description == null) {return ''}
    return htmlSafe(description.replace(/\n/g, '<br>'));
  })
});

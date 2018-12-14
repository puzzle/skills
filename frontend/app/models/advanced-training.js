import DS from 'ember-data';
import DaterangeModel from './daterange-model';
import { computed } from '@ember/object';

export default DaterangeModel.extend({
  description: DS.attr('string'),
  person: DS.belongsTo('person'),

  toString: computed('description', function() {
    return this.get('i18n').t('advancedTraining.name').toString();
  })
});

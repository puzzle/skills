import DS from 'ember-data';
import DaterangeModel from './daterange-model';

export default DaterangeModel.extend({
  description: DS.attr('string'),
  role: DS.attr('string'),
  person: DS.belongsTo('person')
});

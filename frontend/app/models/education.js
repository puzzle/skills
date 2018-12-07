import DS from 'ember-data';
import DaterangeModel from './daterange-model';

export default DaterangeModel.extend({
  title: DS.attr('string'),
  location: DS.attr('string'),
  person: DS.belongsTo('person')
});

import DS from 'ember-data';
import DaterangeModel from './daterange-model';

export default DaterangeModel.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  role: DS.attr('string'),
  technology: DS.attr('string'),
  person: DS.belongsTo('person'),

  projectTechnologies: DS.hasMany('project-technology')
});

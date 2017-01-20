import DS from 'ember-data';
import Person from './person'

export default Person.extend({
  variationName: DS.attr('string'),
  originPersonId: DS.attr('number')
});

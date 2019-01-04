import DS from 'ember-data';
import DaterangeModel from './daterange-model';
import { computed } from '@ember/object';
import { htmlSafe } from '@ember/template';

export default DaterangeModel.extend({
  title: DS.attr('string'),
  description: DS.attr('string'),
  role: DS.attr('string'),
  technology: DS.attr('string'),
  person: DS.belongsTo('person'),

  projectTechnologies: DS.hasMany('project-technology'),

  toString: computed('title', function() {
    return this.get('title');
  }),

  lineBreakDescription: computed('description', function() {
    let description = this.get('description')
    if (description == null) {return ''}
    return htmlSafe(description.replace(/\n/g, '<br>'));
  }),

  lineBreakRole: computed('role', function() {
    let role = this.get('role')
    if (role == null) {return ''}
    return htmlSafe(role.replace(/\n/g, '<br>'));
  }),

  lineBreakTechnology: computed('technology', function() {
    let technology = this.get('technology')
    if (technology == null) {return ''}
    return htmlSafe(technology.replace(/\n/g, '<br>'));
  })
});

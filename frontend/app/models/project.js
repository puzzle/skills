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
    return htmlSafe(this.get('description').replace(/\n/g, '<br>'));
  }),

  lineBreakRole: computed('role', function() {
    return htmlSafe(this.get('role').replace(/\n/g, '<br>'));
  }),

  lineBreakTechnology: computed('technology', function() {
    return htmlSafe(this.get('technology').replace(/\n/g, '<br>'));
  })
});

import Component from '@ember/component';
import { sort } from '@ember/object/computed';

export default Component.extend({
  sortedSkills: sort('skills', 'sortProperties'),

  init() {
    this._super(...arguments);
    this.sortProperties = ['title:asc'];
  }
});

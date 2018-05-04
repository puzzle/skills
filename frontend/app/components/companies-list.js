import Component from '@ember/component';
import { sort } from '@ember/object/computed';

export default Component.extend({
  sortedCompanies: sort("companies", "sortProperties"),

  init() {
    this._super(...arguments);
    this.sortProperties = ['myCompany:desc','level:asc', 'name:asc'];
  }
});

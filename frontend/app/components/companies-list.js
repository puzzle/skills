import Component from '@ember/component';
import { sort } from '@ember/object/computed';

export default Component.extend({
  sortProperties: ['attributes.level:asc', 'attributes.name:asc'],
  sortedCompanies: sort("companies", "sortProperties")
});

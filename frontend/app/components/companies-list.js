import Component from '@ember/component';
import { sort } from '@ember/object/computed';

let sortedCompaniesData = {
  sortProperties: ['attributes.level:asc', 'attributes.name:asc'],
  sortedCompanies: sort("companies", "sortProperties")
};

export default Component.extend({
  sortedCompanies: sortedCompaniesData
});

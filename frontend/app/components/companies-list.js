import Component from '@ember/component';

export default Component.extend({
  sortProperties: ["attributes.level:asc", "attributes.name:asc"],
  sortedCompanies: Ember.computed.sort("companies", "sortProperties")
});

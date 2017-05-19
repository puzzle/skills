import Ember from 'ember';

export default function sortByYear(property) {
  return Ember.computed(`${property}.@each.{year_to,year_from}`, function() {
    let collection = this.get(property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aYearTo = a.get('year_to');
      let bYearTo = b.get('year_to');

      if (aYearTo == null || bYearTo == null) {
        return -1
      }

      let aYearFrom = a.get('year_from');
      let bYearFrom = b.get('year_from');

      if (aYearFrom < bYearFrom) return  1;
      if (aYearFrom > bYearFrom) return -1;

      if (aYearTo < bYearTo) return  1;
      if (aYearTo > bYearTo) return -1;

      return 0;
    });
  });
}

import Ember from 'ember';

export default function sortByYear(property) {
  return Ember.computed(`${property}.@each.{year_to,year_from}`, function() {
    let collection = this.get(property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aYearTo = a.get('year_to')|0;
      let bYearTo = b.get('year_to')|0;

      if (aYearTo === 0 && bYearTo !== 0) return -1;
      if (aYearTo !== 0 && bYearTo === 0) return  1;

      let aYearFrom = a.get('year_from')|0;
      let bYearFrom = b.get('year_from')|0;

      if (aYearFrom < bYearFrom) return  1;
      if (aYearFrom > bYearFrom) return -1;

      if (aYearTo < bYearTo) return  1;
      if (aYearTo > bYearTo) return -1;

      return 0;
    });
  });
}

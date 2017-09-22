import { computed, get } from '@ember/object';

export default function sortByYear(property) {
  return computed(`${property}.@each.{year_to,year_from}`, function() {
    let collection = get(this, property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aYearTo = get(a, 'year_to')|0;
      let bYearTo = get(b, 'year_to')|0;

      if (aYearTo === 0 && bYearTo !== 0) return -1;
      if (aYearTo !== 0 && bYearTo === 0) return  1;

      let aYearFrom = get(a, 'year_from')|0;
      let bYearFrom = get(b, 'year_from')|0;

      if (aYearFrom < bYearFrom) return  1;
      if (aYearFrom > bYearFrom) return -1;

      if (aYearTo < bYearTo) return  1;
      if (aYearTo > bYearTo) return -1;

      return 0;
    });
  });
}

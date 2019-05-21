import { computed, get } from "@ember/object";

export default function sortByYear(property) {
  return computed(`${property}.@each.{yearTo,yearFrom}`, function() {
    let collection = get(this, property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aYearTo = get(a, "yearTo") | 0;
      let bYearTo = get(b, "yearTo") | 0;

      if (aYearTo === 0 && bYearTo !== 0) return -1;
      if (aYearTo !== 0 && bYearTo === 0) return 1;

      if (aYearTo < bYearTo) return 1;
      if (aYearTo > bYearTo) return -1;

      let aMonthTo = get(a, "monthTo") | 0;
      let bMonthTo = get(b, "monthTo") | 0;

      if (aMonthTo === 0 && bMonthTo !== 0) return 1;
      if (aMonthTo !== 0 && bMonthTo === 0) return -1;

      if (aMonthTo < bMonthTo) return 1;
      if (aMonthTo > bMonthTo) return -1;

      let aYearFrom = get(a, "yearFrom") | 0;
      let bYearFrom = get(b, "yearFrom") | 0;

      if (aYearFrom < bYearFrom) return 1;
      if (aYearFrom > bYearFrom) return -1;

      let aMonthFrom = get(a, "monthFrom") | 0;
      let bMonthFrom = get(b, "monthFrom") | 0;

      if (aMonthFrom === 0 && bMonthFrom !== 0) return 1;
      if (aMonthFrom !== 0 && bMonthFrom === 0) return -1;

      if (aMonthFrom < bMonthFrom) return 1;
      if (aMonthFrom > bMonthFrom) return -1;

      return 0;
    });
  });
}

import config from "../config/environment";
export default function sortByYear(properties) {
  if (!properties.promise && config.environment !== "test") return [];
  return properties.toArray().sort((a, b) => {
    let aYearTo = a.yearTo | 0;
    let bYearTo = b.yearTo | 0;

    if (aYearTo === 0 && bYearTo !== 0) return -1;
    if (aYearTo !== 0 && bYearTo === 0) return 1;

    if (aYearTo < bYearTo) return 1;
    if (aYearTo > bYearTo) return -1;

    let aMonthTo = a.monthTo | 0;
    let bMonthTo = b.monthTo | 0;

    if (aMonthTo === 0 && bMonthTo !== 0) return 1;
    if (aMonthTo !== 0 && bMonthTo === 0) return -1;

    if (aMonthTo < bMonthTo) return 1;
    if (aMonthTo > bMonthTo) return -1;

    let aYearFrom = a.yearFrom | 0;
    let bYearFrom = b.yearFrom | 0;

    if (aYearFrom < bYearFrom) return 1;
    if (aYearFrom > bYearFrom) return -1;

    let aMonthFrom = a.monthFrom | 0;
    let bMonthFrom = b.monthFrom | 0;

    if (aMonthFrom === 0 && bMonthFrom !== 0) return 1;
    if (aMonthFrom !== 0 && bMonthFrom === 0) return -1;

    if (aMonthFrom < bMonthFrom) return 1;
    if (aMonthFrom > bMonthFrom) return -1;

    return 0;
  });
}

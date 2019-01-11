import { computed, get } from '@ember/object';

export default function sortByYear(property) {
  function checkForThirteenth(dateA, dateB) {
    if (dateA.getYear() == dateB.getYear()) {
      if (dateA.getDate() === 13 && dateB.getDate() !== 13) return 1;
      if (dateA.getDate() !== 13 && dateB.getDate() === 13) return  -1;
    }
    return null;
  }

  return computed(`${property}.@each.{start_at,finish_at}`, function() {
    let collection = get(this, property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aFinishAt = get(a,'finish_at')
      let bFinishAt = get(b,'finish_at')

      if (aFinishAt === null && bFinishAt !== null) return -1;
      if (aFinishAt !== null && bFinishAt === null) return  1;
      if (aFinishAt !== null && bFinishAt !== null) {
        let result = checkForThirteenth(aFinishAt, bFinishAt)
        if (result !== null) return result;
        if (bFinishAt.getTime() != aFinishAt.getTime()) return bFinishAt - aFinishAt;
      }


      let aStartAt = get(a,'start_at')
      let bStartAt = get(b,'start_at')

      let result = checkForThirteenth(aStartAt, bStartAt)
      if (result !== null) return result;

      if (bStartAt != aStartAt) return bStartAt - aStartAt;

      return 0;
    });
  });
}

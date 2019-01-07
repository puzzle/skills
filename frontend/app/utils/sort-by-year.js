import { computed, get } from '@ember/object';

export default function sortByYear(property) {
  return computed(`${property}.@each.{start_at,finish_at}`, function() {
    let collection = get(this, property);

    if (!collection) return [];

    return collection.toArray().sort((a, b) => {
      let aFinishAt = get(a,'finish_at');
      let bFinishAt = get(b,'finish_at');

      if (aFinishAt === null && bFinishAt !== null) return -1;
      if (aFinishAt !== null && bFinishAt === null) return  1;

      if (bFinishAt != aFinishAt) return bFinishAt - aFinishAt;

      let aStartAt = get(a,'start_at');
      let bStartAt = get(b,'start_at');

      if (bStartAt != aStartAt) return bStartAt - aStartAt;

      return 0;
    });
  });
}

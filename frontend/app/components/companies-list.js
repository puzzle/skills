import Component from "@ember/component";
import { sort } from "@ember/object/computed";

export default Component.extend({
  sortedCompanies: sort("companies", function(a, b) {
    const typeIndexes = {
      mine: 0,
      candidate: 1,
      external: 2,
      other: 3
    };

    let aTypeIndex = typeIndexes[a.get("companyType")];
    let bTypeIndex = typeIndexes[b.get("companyType")];

    if (aTypeIndex != null && bTypeIndex != null && aTypeIndex != bTypeIndex)
      return aTypeIndex - bTypeIndex;

    if (a.get("level") != b.get("level"))
      return a.get("level") - b.get("level");

    return a.get("name") - b.get("name");
  }),

  init() {
    this._super(...arguments);
  }
});

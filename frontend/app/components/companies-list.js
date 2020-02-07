import classic from "ember-classic-decorator";
import { sort } from "@ember/object/computed";
import Component from "@ember/component";

@classic
export default class CompaniesList extends Component {
  @sort("companies", function(a, b) {
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
  })
  sortedCompanies;

  init() {
    super.init(...arguments);
  }
}

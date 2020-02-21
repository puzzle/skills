import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import Component from "@ember/component";

@classic
export default class CompanyProfiles extends Component {
  @computed
  get originalPeople() {
    let people = this.get("company").get("people");
    return people;
  }
}

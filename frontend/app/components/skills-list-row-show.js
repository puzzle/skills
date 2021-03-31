import classic from "ember-classic-decorator";
import { tagName } from "@ember-decorators/component";
import Component from "@ember/component";

@classic
@tagName("tr")
export default class SkillsListRowShow extends Component {
  click() {
    this.sendAction("toggleSkill", this.get("skill"));
  }
}

import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import { inject } from "@ember/service";
import Component from "@ember/component";

@classic
export default class SkillShow extends Component {
  @inject()
  store;

  @computed("skill")
  get peopleSkills() {
    if (this.get("skill.id") != null) {
      return this.get("store").query("peopleSkill", {
        skill_id: this.get("skill.id"),
        rated: "true",
        level: 0,
        interest: 1
      });
    }
    return null;
  }
}

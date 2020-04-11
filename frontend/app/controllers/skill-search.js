import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";

@classic
export default class SkillSearchController extends Controller {
  @service
  store;

  @service
  router;

  currentSkillId = 0;

  init() {
    super.init(...arguments);
    this.set("levelValue", 1);
  }

  @computed
  get skills() {
    return this.store.findAll("skill", { reload: true });
  }

  @computed("model")
  get selectedSkill() {
    const skillId = this.router.currentRoute.queryParams.skill_id;
    this.currentSkillId = skillId;
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @action
  updateSelection() {
    this.get("router").transitionTo({
      queryParams: {
        skill_id: this.currentSkillId,
        level: this.get("levelValue")
      }
    });
  }

  get levelName() {
    const levelNames = [
      "Nicht bewertet",
      "Trainee",
      "Junior",
      "Professional",
      "Senior",
      "Expert"
    ];
    return levelNames[this.get("levelValue")];
  }

  @action
  setSkill(skill) {
    this.get("router").transitionTo({
      queryParams: { skill_id: skill.get("id"), level: this.get("levelValue") }
    });
  }

  @action
  resetFilter() {
    this.set("levelValue", 1);
    this.updateSelection();
  }
}

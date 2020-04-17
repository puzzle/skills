import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { observes } from "@ember-decorators/object";
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
    const skillId = this.get("currentSkillId");
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  updateSelection() {
    this.get("router").transitionTo({
      queryParams: {
        skill_id: this.get("currentSkillId"),
        level: this.get("levelValue")
      }
    });
  }

  @observes("levelValue")
  levelValueChanged() {
    this.updateSelection();
  }

  @observes("currentSkillId")
  skillValueChanged() {
    this.updateSelection();
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
    this.set("currentSkillId", skill.get("id"));
  }

  @action
  resetFilter() {
    this.set("levelValue", 1);
    this.updateSelection();
  }
}

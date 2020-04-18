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

  currentSkillId = [0, 0, 0, 0, 0];
  count = 1;
  duplicate = [0, 0, 0, 0, 0]; //Not really elegant, but could not figure out a different way to change currentSkillId

  init() {
    super.init(...arguments);
    this.set("levelValue1", 1);
    this.set("levelValue2", 1);
    this.set("levelValue3", 1);
    this.set("levelValue4", 1);
    this.set("levelValue5", 1);
    this.set("count", 1);
  }

  @computed
  get skills() {
    return this.store.findAll("skill", { reload: true });
  }

  @action
  updateSelection() {
    let skill_ids = "",
      levels = "";
    for (let i = 0; i < this.count; i++) {
      if (this.currentSkillId[i] != 0) {
        skill_ids = skill_ids + "," + this.currentSkillId[i];
        levels = levels + "," + this.get("levelValue" + (i + 1));
      }
    }
    if (skill_ids.length > 0) {
      skill_ids = skill_ids.substring(1);
      levels = levels.substring(1);
    }
    this.get("router").transitionTo({
      queryParams: {
        skill_id: skill_ids,
        level: levels
      }
    });
  }

  @action
  setSkill(num, skill) {
    this.resetDuplicate();
    this.duplicate[num - 1] = parseInt(skill.get("id"));
    this.set("currentSkillId", this.duplicate);
    console.log(this.currentSkillId);
    this.updateSelection();
  }

  @action
  removeFilter(num) {
    for (let i = num; i < this.count; i++) {
      this.resetDuplicate();
      this.duplicate[i - 1] = this.duplicate[i];
      this.set("currentSkillId", this.duplicate);
      this.set("levelValue" + i, this.get("levelValue" + (i + 1)));
      console.log(this.currentSkillId);
    }
    if (this.count > 1) {
      this.set("count", this.count - 1);
    }
    this.set("levelValue" + (this.count + 1), 1);
    this.resetDuplicate();
    this.duplicate[this.count] = 0;
    this.set("currentSkillId", this.duplicate);
    this.updateSelection();
    console.log(this.currentSkillId);
  }

  @action
  resetFilter(num) {
    this.set("levelValue" + num, 1);
    this.resetDuplicate();
    this.duplicate[num - 1] = 0;
    this.set("currentSkillId", this.duplicate);
  }

  @action
  addFilter() {
    this.set("count", this.count + 1);
  }

  resetDuplicate() {
    this.duplicate = [
      this.currentSkillId[0],
      this.currentSkillId[1],
      this.currentSkillId[2],
      this.currentSkillId[3],
      this.currentSkillId[4]
    ];
  }
}

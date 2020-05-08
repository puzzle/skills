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

  currentSkillId = [null, null, null, null, null];
  count = 1;

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

  @computed("model")
  get selectedSkill1() {
    const skillId = this.currentSkillId[0];
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @computed("model")
  get selectedSkill2() {
    const skillId = this.currentSkillId[1];
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @computed("model")
  get selectedSkill3() {
    const skillId = this.currentSkillId[2];
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @computed("model")
  get selectedSkill4() {
    const skillId = this.currentSkillId[3];
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @computed("model")
  get selectedSkill5() {
    const skillId = this.currentSkillId[4];
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  updateSelection() {
    let skill_ids = "",
      levels = "";
    for (let i = 0; i < this.count; i++) {
      if (this.currentSkillId[i] !== null) {
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

  @computed("model")
  get sortSelection() {
    let sortedSkills = this.model.toArray().sort(function(a, b) {
      let x = a.person.get("name").localeCompare(b.person.get("name"));
      return x == 0
        ? a.skill.get("title").localeCompare(b.skill.get("title"))
        : x;
    });
    return sortedSkills;
  }

  @action
  setSkill(num, skill) {
    let duplicate = this.getDuplicate();
    duplicate[num - 1] = parseInt(skill.get("id"));
    this.set("currentSkillId", duplicate);
  }

  @action
  removeFilter(num) {
    for (let i = num; i < this.count; i++) {
      let duplicate = this.getDuplicate();
      duplicate[i - 1] = duplicate[i];
      this.set("currentSkillId", duplicate);
      this.set("levelValue" + i, this.get("levelValue" + (i + 1)));
    }
    if (this.count > 1) {
      this.set("count", this.count - 1);
    }
    this.set("levelValue" + (this.count + 1), 1);
    let duplicate = this.getDuplicate();
    duplicate[this.count] = null;
    this.set("currentSkillId", duplicate);
  }

  @observes(
    "levelValue1",
    "levelValue2",
    "levelValue3",
    "levelValue4",
    "levelValue5",
    "currentSkillId"
  )
  valueChanged() {
    this.updateSelection();
  }

  @action
  resetFilter(num) {
    this.set("levelValue" + num, 1);
    let duplicate = this.getDuplicate();
    duplicate[num - 1] = null;
    this.set("currentSkillId", duplicate);
  }

  @action
  addFilter() {
    this.set("count", this.count + 1);
  }

  getDuplicate() {
    return [
      this.currentSkillId[0],
      this.currentSkillId[1],
      this.currentSkillId[2],
      this.currentSkillId[3],
      this.currentSkillId[4]
    ];
  }
}

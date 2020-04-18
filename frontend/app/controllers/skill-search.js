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
  t = [0, 0, 0, 0, 0];

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
    this.get("router").transitionTo({
      queryParams: {
        skill_id: this.currentSkillId[0],
        level: this.get("levelValue1")
      }
    });
  }

  @action
  setSkill(num, skill) {
    this.t = [
      this.currentSkillId[0],
      this.currentSkillId[1],
      this.currentSkillId[2],
      this.currentSkillId[3],
      this.currentSkillId[4]
    ];
    this.t[num - 1] = parseInt(skill.get("id"));
    this.set("currentSkillId", this.t);
    console.log(this.currentSkillId);
    this.get("router").transitionTo({
      queryParams: { skill_id: skill.get("id"), level: this.get("levelValue1") }
    });
  }

  @action
  resetFilter(num) {
    for (let i = num; i < this.count; i++) {
      this.t = [
        this.currentSkillId[0],
        this.currentSkillId[1],
        this.currentSkillId[2],
        this.currentSkillId[3],
        this.currentSkillId[4]
      ];
      this.t[i - 1] = this.t[i];
      this.set("currentSkillId", this.t);
      this.set("levelValue" + i, this.get("levelValue" + (i + 1)));
      console.log(this.currentSkillId);
    }
    if (this.count > 1) {
      this.set("count", this.count - 1);
    }
    this.set("levelValue" + (this.count + 1), 1);
    this.t = [
      this.currentSkillId[0],
      this.currentSkillId[1],
      this.currentSkillId[2],
      this.currentSkillId[3],
      this.currentSkillId[4]
    ];
    this.t[this.count] = 0;
    this.set("currentSkillId", this.t);
    this.updateSelection();
    console.log(this.currentSkillId);
  }

  @action
  addFilter() {
    this.set("count", this.count + 1);
  }
}

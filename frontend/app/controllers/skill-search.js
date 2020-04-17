import classic from "ember-classic-decorator";
import { action, computed, set } from "@ember/object";
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
    //this.currentSkillId[num-1] = skill.get("id");
    set(this.currentSkillId, (num - 1).toString(), skill.get("id"));
    console.log(this.currentSkillId);
    this.get("router").transitionTo({
      queryParams: { skill_id: skill.get("id"), level: this.get("levelValue1") }
    });
  }

  @action
  resetFilter(num) {
    for (let i = this.count; i > num; i--) {
      //this.currentSkillId[i-1] = this.currentSkillId[i];
      this.set("levelValue" + (i - 1), this.get("levelValue" + i));
    }
    if (this.count > 1) {
      this.set("count", this.count - 1);
    }
    this.set("levelValue" + (this.count + 1), 1);
    //this.currentSkillId[this.count + 1] = 0;
    this.updateSelection();
  }

  @action
  addFilter() {
    this.set("count", this.count + 1);
  }
}

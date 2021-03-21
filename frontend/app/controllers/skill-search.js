import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { observes } from "@ember-decorators/object";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";
import PeopleSkill from "../models/people-skill";
import { tracked } from "@glimmer/tracking";

@classic
export default class SkillSearchController extends Controller {
  @service
  store;

  @service
  router;

  @tracked
  levelValue = this.level || 1;

  currentSkillId = this.skill_id;

  @tracked
  skills = this.store.findAll("skill", { reload: true });

  @computed("model", "skills")
  get selectedSkill() {
    const skillId = this.skill_id;
    return skillId ? this.store.peekRecord("skill", skillId) : null;
  }

  updateSelection() {
    this.router.transitionTo({
      queryParams: {
        skill_id: this.currentSkillId,
        level: this.levelValue
      }
    });
  }

  @observes("levelValue", "currentSkillId")
  valueChanged() {
    this.updateSelection();
  }

  get levelName() {
    return PeopleSkill.LEVEL_NAMES[this.levelValue];
  }

  @action
  setSkill(skill) {
    this.set("currentSkillId", skill.get("id"));
  }

  @action
  resetFilter() {
    this.set("levelValue", 1);
    this.set("currentSkillId", 0);
  }
}

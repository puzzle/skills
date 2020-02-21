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

  @computed
  get skills() {
    return this.store.findAll("skill", { reload: true });
  }

  @computed("model")
  get selectedSkill() {
    const skillId = this.router.currentRoute.queryParams.skill_id;
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @action
  setSkill(skill) {
    this.get("router").transitionTo({
      queryParams: { skill_id: skill.get("id") }
    });
  }
}

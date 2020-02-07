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

  init() {
    super.init(...arguments);
    this.set("skills", this.get("store").findAll("skill")).then(() =>
      this.notifyPropertyChange("selectedSkill")
    );
  }

  @computed("model")
  get selectedSkill() {
    let skillId = this.get(
      "router.currentState.routerJsState.queryParams.skill_id"
    );
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }

  @action
  setSkill(skill) {
    this.get("router").transitionTo({
      queryParams: { skill_id: skill.get("id") }
    });
  }
}

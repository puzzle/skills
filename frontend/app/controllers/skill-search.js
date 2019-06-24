import Controller from "@ember/controller";
import { inject as service } from "@ember/service";
import { computed } from "@ember/object";

export default Controller.extend({
  store: service(),
  router: service(),

  init() {
    this._super(...arguments);
    this.set("skills", this.get("store").findAll("skill")).then(() =>
      this.notifyPropertyChange("selectedSkill")
    );
  },

  selectedSkill: computed("model", function() {
    let skillId = this.get(
      "router.currentState.routerJsState.queryParams.skill_id"
    );
    return skillId ? this.get("store").peekRecord("skill", skillId) : null;
  }),

  results: computed("model", function() {
    return this.get("model")
      ? this.get("model").filter(ps => ps.get("isRated"))
      : null;
  }),

  actions: {
    setSkill(skill) {
      this.get("router").transitionTo({
        queryParams: { skill_id: skill.get("id") }
      });
    }
  }
});

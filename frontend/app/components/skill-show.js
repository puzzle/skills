import Component from "@ember/component";
import { computed } from "@ember/object";
import { inject } from "@ember/service";

export default Component.extend({
  store: inject(),

  peopleSkills: computed("skill", function() {
    if (this.get("skill.id") != null) {
      return this.get("store").query("peopleSkill", {
        skill_id: this.get("skill.id")
      });
    }
  })
});

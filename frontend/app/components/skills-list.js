import Component from "@ember/component";
import { sort } from "@ember/object/computed";
import { inject as service } from "@ember/service";

export default Component.extend({
  download: service(),
  sortedSkills: sort("skills", "sortProperties"),

  init() {
    this._super(...arguments);
    this.sortProperties = ["title:asc"];
  },

  actions: {
    exportSkillsetOdt(e) {
      e.preventDefault();
      let url = "/api/skills?format=odt";
      this.get("download").file(url);
    },

    toggleSkill(skill) {
      this.set("currentSkill", skill);
    },

    refreshList(skill) {
      this.set(
        "skills",
        this.get("skills")
          .toArray()
          .addObject(skill)
      );
    }
  }
});

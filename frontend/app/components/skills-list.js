import Component from "@ember/component";
import { sort } from "@ember/object/computed";
import { computed } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  store: service(),
  download: service(),
  sortedSkills: sort("skills", (a, b) => {
    // this is needed because otherwise the skills would get reordered
    // while editing and saving a skill without a title
    if (a.get("title") === "" || b.get("title") === "") return 0;
    return a.get("title") - b.get("title");
  }),

  init() {
    this._super(...arguments);
    this.set("editSkills", []);
    this.set(
      "categories",
      this.get("store").findAll("category", { reload: true })
    );
  },

  parentCategories: computed("categories", function() {
    return this.get("categories").then(categories =>
      categories.toArray().filter(c => !c.get("parent.content"))
    );
  }),

  childCategories: computed("categories", function() {
    return this.get("categories").then(categories =>
      categories.toArray().filter(c => Boolean(c.get("parent.content")))
    );
  }),

  actions: {
    exportSkillsetOdt(e) {
      e.preventDefault();
      let url = "/api/skills?format=odt";
      this.get("download").file(url);
    },

    startEditing(skill) {
      this.editSkills.addObject(skill);
    },

    stopEditing(skill) {
      this.editSkills.removeObject(skill);
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

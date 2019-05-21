import Component from "@ember/component";
import { computed, observer } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  store: service(),

  init() {
    this._super(...arguments);
    this.parentCategories = this.get("store").query("category", {
      scope: "parents"
    });
    this.refreshCoreCompetencesObj();
  },

  personChanged: observer("person.peopleSkills", function() {
    this._super(...arguments);
    this.refreshCoreCompetencesObj();
  }),

  refreshCoreCompetencesObj() {
    let hash = {};
    this.get("parentCategories").then(parentCategories => {
      parentCategories.toArray().forEach(category => {
        let skills = category
          .get("childrenSkills")
          .map(skill => {
            if (
              this.get("coreCompetenceSkills")
                .map(s => s.get("id"))
                .includes(skill.get("id"))
            )
              return skill;
          })
          .filter(s => s !== undefined);
        if (skills.length) hash[category.get("title")] = skills;
      });
      this.set("coreCompetencesObj", hash);
    });
  },

  coreCompetenceSkills: computed("person.peopleSkills", function() {
    return this.get("person.peopleSkills")
      .map(ps => {
        if (ps.get("coreCompetence")) return ps.get("skill");
      })
      .filter(s => s !== undefined);
  }),

  coreCompetenceSkillsAmount: computed("coreCompetenceSkills", function() {
    return this.get("coreCompetenceSkills.length");
  })
});

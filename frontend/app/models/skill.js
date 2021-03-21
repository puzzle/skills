import Model, { attr, hasMany, belongsTo } from "@ember-data/model";
import { computed } from "@ember/object";

const Skill = Model.extend({
  title: attr("string"),
  radar: attr("string"),
  portfolio: attr("string"),
  defaultSet: attr("boolean", { allowNull: true }),

  people: hasMany("person"),
  peopleSkills: hasMany("people-skill"),
  category: belongsTo("category", { inverse: "skills" }),
  parentCategory: belongsTo("category", {
    inverse: "childrenSkills",
    readOnly: true
  }),

  instanceToString: computed("title", function() {
    return this.title;
  })
});

Skill.reopenClass({
  RADAR_OPTIONS: {
    hold: "hold",
    adopt: "adopt",
    trial: "trial",
    divorced: "assess"
  },

  PORTFOLIO_OPTIONS: { active: "aktiv", passive: "passiv", reduce: "abbauen" }
});

export default Skill;
